contract Community {

    event Request(address indexed applicant, bytes32 indexed request, uint256 hash);
    event Reject(address indexed applicant);
    event Accept(address indexed applicant);
    event Remove(address indexed applicant);

    mapping(address => uint) public index;
    bytes32[] public requests;
    address[] public applicants;
    uint256[] public hashes;

    mapping(address => bool) public members;
    
    modifier onlyOwner {}

    function isMember(address _member) constant returns (bool) {}

    function addMember(address _applicant) onlyOwner returns (bool) {}

    function remMember(address _member) onlyOwner returns (bool) {}

    function request(address _applicant, bytes32 _request, uint256 _hash) returns (bool) {}

    function reject(address _applicant) onlyOwner returns (bool) {}

}