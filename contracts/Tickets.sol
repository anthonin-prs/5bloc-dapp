// SPDX-License-Identifier: GPL-3.0

/// @title Contract that allow ticket selling system
/// @author 5BLOC - SUPINFO 2022
/// @notice It will allow you to buy ticket to use on metro/bus/train and apply reductions based on your reduction cards

pragma solidity >=0.7.0 <0.9.0;

contract Tickets {
    address public contract_owner;
    address public card_contract_address;
    uint256 public ticket_price;

    mapping(address => bool) public admins;
    mapping(address => uint256) public tickets;

    event ticketBuy(address user, uint256 amount);
    event ticketUse(address user, uint256 amount);
    event adminEdit(address user, string action);

    /**
     * @dev Create a "ticket selling machine"
     * @param base_price default price for tickets (in gwei)
     * @param cardContract address of the card contract
     */
    constructor(uint256 base_price, address cardContract) {
        contract_owner = msg.sender;
        admin_set(contract_owner);
        ticket_price = base_price * 10e8;
        card_contract_address = cardContract;
    }

    /**
     * @dev Set a user admin
     * @param _user user address who will become admin (require to be owner to play)
     */
    function admin_set(address _user) public {
        require(
            msg.sender == contract_owner,
            "You need to be owner to set a new admin"
        );
        admins[_user] = true;
        emit adminEdit(_user, "set");
    }

    /**
     * @dev Revoke user admin power
     * @param _user user address who admin power will be revoked (require to be owner to play)
     */
    function admin_revoke(address _user) public {
        require(
            msg.sender == contract_owner,
            "You need to be owner to revoke an existing admin"
        );
        admins[_user] = false;
        emit adminEdit(_user, "revoke");
    }

    /**
     * @dev Buy a ticket
     * @param _amount number of tickets wanted, require exact value as msg.value
     */
    function ticket_buy(uint256 _amount) external payable {
        uint256 order_value = calculate_ticket_price(_amount);

        require(msg.value == order_value, "Need to send exact amount of ETH");

        (bool sent, bytes memory data) = contract_owner.call{
            value: order_value
        }("");
        require(sent, "Failed to send Tickets");
        data = data;
        tickets[msg.sender] += _amount;

        emit ticketBuy(msg.sender, _amount);
    }

    /**
     * @dev Get ticket price
     * @param _amount number of tickets wanted, require exact value as msg.value
     */
    function calculate_ticket_price(uint256 _amount)
        public
        view
        returns (uint256)
    {
        DiscountCards card_contract = DiscountCards(card_contract_address);
        uint256 user_best_reduction = card_contract.getBiggestReduct(
            msg.sender
        );

        uint256 base_price = _amount * ticket_price * 100;

        uint256 final_price;
        if (user_best_reduction > 0) {
            final_price =
                (base_price * (100 - user_best_reduction)) /
                (10**(2**2));
        } else {
            final_price = base_price;
        }
        return final_price;
    }

    /**
     * @dev Use a ticket
     * @param _amount amount of ticket to use for defined user
     * @param _user user which tickets will be used
     */
    function ticket_use(uint256 _amount, address _user) public {
        require(admins[msg.sender], "You need to be admin to use tickets");
        require(
            tickets[_user] >= _amount,
            "User don't have enough tickets left"
        );
        tickets[_user] -= _amount;
        emit ticketUse(_user, _amount);
    }
}
