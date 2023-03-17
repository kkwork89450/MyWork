pragma solidity ^0.8.14;

contract Voting{
    address[] votingAddressArray;
    mapping (address => uint) addressToId;

    function uintToStr(uint _i) public pure returns(string memory str){
        if (_i == 0){
            str = "0";
            return str;
        }
        uint j = _i;
        uint length;
        while (j != 0){
            length ++ ;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint k = length;
        j = _i;
        while (j != 0){
            bstr[--k] = bytes1(uint8(48 + j%10));
            j /= 10;
        }
        str = string(bstr);
    }

    function registration(address myAddress) public{
        addressToId[myAddress] = votingAddressArray.length;
        votingAddressArray.push(myAddress);
    }

    function check_reg(address myAddress) public view returns (string memory){
        uint i = addressToId[myAddress];
        if (votingAddressArray[i] == myAddress){
            return "You have been successfully registered.";
        }
        else{
            return "You have not been registered.";
        }
    }

    enum VoteStatus{Voted, NotYetVoted}
    VoteStatus voteStatus = VoteStatus.NotYetVoted;
    enum VotedCandidate{Cand1, Cand2, Cand3}
    VotedCandidate votedCandidate;
    struct voteCount{uint cand1; uint cand2; uint cand3;}
    voteCount VoteCount;
    modifier onlyRegistered(){
        uint i = addressToId[msg.sender];
        require(msg.sender == votingAddressArray[i], "You have not yet registered, please vote after registration.");
        _;
    }

    function vote(uint voteCand) public onlyRegistered onlyNotVoted returns (string memory votedStr){
        require (voteCand >= 1 && voteCand <= 3, "There are only 3 candidates");
        voteCand -- ;
        votedCandidate = VotedCandidate(voteCand);
        voteCand ++ ;
        votedStr = string.concat("You have voted Candidate ", uintToStr(voteCand));
        if (voteCand == 1){
            VoteCount.cand1 ++ ;
        }
        if (voteCand == 2){
            VoteCount.cand2 ++ ;
        }
        if (voteCand == 3){
            VoteCount.cand3 ++ ;
        }
        voteStatus = VoteStatus.Voted;
        return votedStr;
    }

    modifier onlyNotVoted(){
        require (voteStatus == VoteStatus.NotYetVoted);
        _;
    }

    function VOTECOUNT() public view returns (uint[3] memory){
        uint[3] memory votecountArray = [VoteCount.cand1, VoteCount.cand2, VoteCount.cand3];
        return votecountArray;
    }
}
