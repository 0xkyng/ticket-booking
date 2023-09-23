// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract TicketBooking {
    uint public constant totalSeats = 20;
    uint public constant maxTickets = 4;

    address public owner;
    mapping(uint => bool) public availableSeats;
    mapping(address => uint[]) public bookedSeats;
    mapping(uint => bool) private repeatedSeat; 

    constructor() {
        owner = msg.sender;
        for (uint i = 1; i <= totalSeats; i++) {
            availableSeats[i] = true;
        }
    }

    error invalidLength();
    error arrayCannotBeEmpty();
    error arrayLengthExceeded();
    error seatIsNotAvailable();
    error invalidSeatNumber();
    error seatNumberRepeated();
    error ownerCannotBookLastSeat();

    function bookSeats(uint[] memory seatNumbers) public {
        if (seatNumbers.length == 0) revert arrayCannotBeEmpty();
        if (seatNumbers.length > maxTickets) revert arrayLengthExceeded();
        for (uint i = 0; i < seatNumbers.length; i++) {
            uint seatNumber = seatNumbers[i];
            if (seatNumber < 1 || seatNumber > 20) revert invalidSeatNumber();
            if (repeatedSeat[seatNumber]) revert seatNumberRepeated();
            repeatedSeat[seatNumber] = true;

            availableSeats[seatNumber] = false;
            bookedSeats[msg.sender].push(seatNumber);
            if (seatNumber == 20 && owner == msg.sender) revert ownerCannotBookLastSeat();
        }
    }

    function showAvailableSeats() public view returns (uint[] memory) {
        uint[] memory _availableSeats = new uint[](totalSeats);
        uint count = 0;
        for (uint i = 1; i <= totalSeats; i++) {
            if (availableSeats[i]) {
                _availableSeats[count] = i;
                count++;
            }
        }
        assembly {
            mstore(_availableSeats, count)
        }
        return _availableSeats;
    }

    function checkAvailability(uint seatNumber) public view returns (bool) {
        if (seatNumber < 1 || seatNumber > 20) revert invalidSeatNumber();
        return availableSeats[seatNumber];
    }

    function myTickets() public view returns (uint[] memory) {
        return bookedSeats[msg.sender];
    }
}