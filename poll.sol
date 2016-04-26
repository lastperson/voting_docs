contract IdentityProvider {

    function isMember(address _member) constant returns (bool) {}

}

contract Poll {
    uint public start;
    uint public end;
    uint8[] public answerCount;
    string public questions;
    uint counter;
    address[] public idVers;
    address organizer;
    
    mapping(address => uint) public index;
    address[] public voters;
    uint8[][] public ballots;
    
    uint[][] public results;
    
    event Vote (address indexed voter, bytes32 indexed hash);
    
    function setParams(uint _start, uint _end, uint8[] _answerCount, address[] _idVers, string _questions) returns (bool) {
        if (organizer != 0x0) {
            return false;
        }
        organizer = tx.origin;
        voters.length++;
        ballots.length++;
        questions = _questions;
        start = _start;
        end = _end;
        answerCount = _answerCount;
        idVers = _idVers;
        return true;
    }

    function answersLength() constant returns (uint) {
        if (answerCount.length == 0) {
            return results.length;
        } else {
            return answerCount.length;
        }
    }
    
    modifier onlyVerified {
        _
        for (uint i = 0; i < idVers.length; i++) {
            IdentityProvider ip = IdentityProvider(idVers[i]);
            if (ip.isMember(tx.origin)) {
                _
            }
        }
    }
    
    function cast(uint8[] _ballot) onlyVerified returns (bytes32) {
        return _castTimed(_ballot, now);
    }

    // DEPLOY REMOVE START
    function castTimed(uint8[] _ballot, uint _now) onlyVerified returns (bytes32) {
        return _castTimed(_ballot, _now);
    }
    // DEPLOY REMOVE END

    function _castTimed(uint8[] _ballot, uint _now) internal returns (bytes32) {
        if (start <= _now && _now <= end && _ballot.length == answerCount.length) {
            for (uint j = 0; j < answerCount.length; j++) {
                if (_ballot[j] > answerCount[j]) {
                    _ballot[j] = 0;
                }
            }
            uint pos = index[tx.origin];
            if (pos == 0) {
                pos = voters.length++;
                ballots.length++;
            }
            voters[pos] = tx.origin;
            ballots[pos] = _ballot;
            index[tx.origin] = pos;
            counter++;
            bytes32 hash = sha3(counter + pos + _now);
            Vote(tx.origin, hash);
            return hash;
        }
    }

    function checkResults() constant returns(bytes32[]) {
        uint length = 0;
        for (uint i = 0; i < answerCount.length; i++) {
            length += answerCount[i];
        }
        bytes32[] memory result = new bytes32[](length + answerCount.length);
        uint pos = 0;
        for (uint8 q = 0; q < uint8(answerCount.length); q++) {
            result[pos] = bytes32(q);
            for (uint ballot = 1; ballot < ballots.length; ballot++) {
                uint8 answer = ballots[ballot][q];
                if (answer > 0) {
                    result[pos+answer] = bytes32(uint(result[pos+answer])+1);
                }
            }
            pos += answerCount[q] + 1;
        }
        return result;
    }
    
    function count() returns (bool) {
        return _countTimed(now);
    }

    // DEPLOY REMOVE START
    function countTimed(uint _now) returns (bool) {
        return _countTimed(_now);
    }
    // DEPLOY REMOVE END

    function _countTimed(uint _now) internal returns (bool) {
        if (_now >= end && results.length == 0) {
            results.length = answerCount.length;
            for (uint8 q = uint8(answerCount.length); q > 0; q--) {
                results[q-1].length = answerCount[q-1]+1;
                for (uint ballot = 1; ballot < ballots.length; ballot++) {
                    results[q-1][ballots[ballot][q-1]]++;
                }
                answerCount.length--;
            }
            return true;
        }
        return false;
    }
}
