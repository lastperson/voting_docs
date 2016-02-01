contract VoteRegistry {

    event Provider(address provider);
    event Poll(address poll);
    
    mapping(address => uint) public provIndex;
    address[] public providers;
    string[] public provNames;
    address[] public owners;
    
    mapping(address => uint) public pollIndex;
    string[] public pollNames;
    address[] public polls;
    
    modifier onlyOwner(address _provider) {}
    
    function addProvider(address _provider, string _name) returns (bool) {}
    
    function remProvider(address _provider) onlyOwner(_provider) returns (bool) {}
    
    function addPoll(address _poll, string _name) returns (bool) {}

    function remPoll(address _poll) onlyOwner(_poll) returns (bool) {}

}