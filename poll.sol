contract Poll {
    uint public start;
    uint public end;
    uint8[] public answerCount;
    string public questions;
    address[] public idVers;
    
    mapping(address => uint) public index;
    address[] public voters;
    uint8[][] public ballots;
    
    uint[][] public results;
    
    event Vote (address indexed voter, bytes32 indexed hash);
    
    function setParams(uint _start, uint _end, uint8[] _answerCount, address[] _idVers, string _questions) returns (bool) {}

    function answersLength() constant returns (uint) {}
    
    modifier onlyVerified {}
    
    function cast(uint8[] _ballot) onlyVerified returns (bytes32) {}
    
    function count() returns (bool) {}
    
}