
# Voting Registry

The registry bootstraps the System. It manages Community and Poll contracts. A registy contract is deployed at `0x335d44e65c592110289b9119006af96d0726cd65`

# Voting Community

Different communities can be set up. Their task to to KYC accounts of voters.

# Polls

Polls can be created by organizers. Beforhand, the organizer has to select one or many communities. The verified members of those communities will be allowed to cast a ballot in this poll.

#Reading Poll list and Poll details from Node.js

##Installing web 3
```
npm install web3
```

##initializing web 3
```javascript
var web3Provider = 'http://52.28.142.166:8545/';
var web3 = new Web3();
web3.setProvider(new web3.providers.HttpProvider(web3Provider));
```
 
##using registration contract to read a list of polls
```javascript
var fromBlock = 869624;
var regAddress = '0x335d44e65c592110289b9119006af96d0726cd65';
var regAbi = '[{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"owners","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"providers","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"provNames","outputs":[{"name":"","type":"string"}],"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"pollNames","outputs":[{"name":"","type":"string"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"polls","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"pollIndex","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"_poll","type":"address"},{"name":"_name","type":"string"}],"name":"addPoll","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"_provider","type":"address"}],"name":"remProvider","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"provIndex","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"_provider","type":"address"},{"name":"_name","type":"string"}],"name":"addProvider","outputs":[{"name":"","type":"bool"}],"type":"function"},{"inputs":[],"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"provider","type":"address"}],"name":"Provider","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"poll","type":"address"}],"name":"Poll","type":"event"}]';
var regContract = web3.eth.contract($.parseJSON(regAbi)).at(regAddress);
regContract.allEvents({fromBlock: fromBlock, toBlock: 'latest'}, function(err,op) {
  if (op.event === 'Poll') {
    console.log('found poll at address: ' + op.args.poll);
    //read name of poll
    regContract.pollIndex(op.args.poll, function(error, index) {
      regContract.pollNames(index, function(error, name) {
        console.log('poll at address: ' + op.args.poll + 'is named ' + name);
      });
    });
  }
});
```

##using poll contract to read poll details
```javascript
var pollAddress = 'see section "using registration contract to read a list of polls"';
var pollAbi = '[{"constant":false,"inputs":[],"name":"count","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"idVers","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"index","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"_now","type":"uint256"}],"name":"countTimed","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":true,"inputs":[],"name":"questions","outputs":[{"name":"","type":"string"}],"type":"function"},{"constant":false,"inputs":[{"name":"_ballot","type":"uint8[]"},{"name":"_now","type":"uint256"}],"name":"castTimed","outputs":[{"name":"","type":"bytes32"}],"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"},{"name":"_end","type":"uint256"},{"name":"_answerCount","type":"uint8[]"},{"name":"_idVers","type":"address[]"},{"name":"_questions","type":"string"}],"name":"setParams","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"_ballot","type":"uint8[]"}],"name":"cast","outputs":[{"name":"","type":"bytes32"}],"type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"},{"name":"","type":"uint256"}],"name":"results","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"voters","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[],"name":"answersLength","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"answerCount","outputs":[{"name":"","type":"uint8"}],"type":"function"},{"constant":true,"inputs":[],"name":"end","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"},{"name":"","type":"uint256"}],"name":"ballots","outputs":[{"name":"","type":"uint8"}],"type":"function"},{"inputs":[],"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"voter","type":"address"},{"indexed":true,"name":"hash","type":"bytes32"}],"name":"Vote","type":"event"}]';
var pollContract = web3.eth.contract($.parseJSON(pollAbi)).at(pollAddress);
pollContract.start(function(error, startTime) {
  console.log('poll at address: ' + pollAddress + ' will start at ' + startTime);
});
pollContract.end(function(error, endTime) {
  console.log('poll at address: ' + pollAddress + ' will end at ' + endTime);
});
pollContract.answersLength(function(error, count) {
  console.log('poll at address: ' + pollAddress + ' has ' + count + 'questions.');
});
```

#Managing Community from Geth Console

## Binding to contract

```javascript
> var comm = web3.eth.contract([{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"members","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"_newOwner","type":"address"}],"name":"setOwner","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"index","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"_member","type":"address"}],"name":"remMember","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"hashes","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"applicants","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"requests","outputs":[{"name":"","type":"bytes32"}],"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"_member","type":"address"}],"name":"isMember","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"_applicant","type":"address"}],"name":"reject","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"_applicant","type":"address"}],"name":"addMember","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"_applicant","type":"address"},{"name":"_request","type":"bytes32"},{"name":"_hash","type":"uint256"}],"name":"request","outputs":[{"name":"","type":"bool"}],"type":"function"},{"inputs":[],"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"applicant","type":"address"},{"indexed":true,"name":"request","type":"bytes32"},{"indexed":false,"name":"hash","type":"uint256"}],"name":"Request","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"applicant","type":"address"}],"name":"Reject","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"applicant","type":"address"}],"name":"Accept","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"applicant","type":"address"}],"name":"Remove","type":"event"}]).at("0xa92cff3d614fd9dca7e873eaa6bbdd818b3fad3e");
undefined
> > comm.address
"0xa92cff3d614fd9dca7e873eaa6bbdd818b3fad3e"
```

## Setting Contract Owner

The Owner is the admin of the contract. Only the current owner can appoint a new owner.  The owner is the only one who can approve and reject member applications.

```javascript
> comm.setOwner.sendTransaction("0x00da0847592774280c84b106dce8d54c39b5b5f6",{from:eth.accounts[0], gas: 120000});
"0xb8a3f4b7a1537885f4bb1982c9b402901c675367a132df712baeca9bb2b9d2af"
> comm.owner()
"0x00da0847592774280c84b106dce8d54c39b5b5f6"
```

## Requesting Membership in Community

This call is unrestricted. Everyone can submit an application to it. The application consists of the account address, a URI to a JSON object holding application data, and a SHA-hash of the content of the application. 

```javascript
> comm.request.sendTransaction("0xe6b032b23bc145ed19e23792e2a107d0794fe65a","http://some.url/application.json","0x123567",{from:eth.accounts[0], gas: 150000});
"0x669b8c0dba902e7a727749278acc3e2c9c44b02af72885385745e26febd9188f"
```
This will trigger the `event Request(address indexed applicant, bytes32 indexed request, uint256 hash);` event on the contract. After an application is submitted the application data can be queried by address.

```javascript
> comm.index("0xe6b032b23bc145ed19e23792e2a107d0794fe65a");
1
> comm.requests(1);
"0x687474703a2f2f736f6d652e75726c2f6170706c69636174696f6e2e6a736f6e"
> comm.applicants(1);
"0xe6b032b23bc145ed19e23792e2a107d0794fe65a"
> comm.hashes(1);
1193319
```

## Managing Applications

Pending applications can be approved or rejected. Once accepted, accounts become Members. The Poll conract will call the `isMember(addr)` function when a ballot is casted. Any rejected account can apply again. Member accounts can also be removed and apply again.

### Rejecting Application

Any pending Application can be rejected and will be removed from contract storage. Once rejected account can apply again.

```javascript
> comm.reject.sendTransaction("0xe6b032b23bc145ed19e23792e2a107d0794fe65a",{from:eth.accounts[0], gas: 150000});
"0x6934bea5a2da7e44afbb0ad4f69ace60b38e0e45ca45e5d954024a28c19e0669"
> comm.index("0xe6b032b23bc145ed19e23792e2a107d0794fe65a");
0
```

This will trigger the `Reject(address indexed applicant);` event on the contract.

### Accepting Applications

Once an application is accepted its address is removed from the pending applications. 

```javascript
> comm.addMember.sendTransaction("0xe6b032b23bc145ed19e23792e2a107d0794fe65a",{from:eth.accounts[0], gas: 150000});
"0xac859e43fea980e65e469b0dafeceb510d572b8e0b20f83ef18f272a2e74d04f"
> comm.index("0xe6b032b23bc145ed19e23792e2a107d0794fe65a");
0
```
This will trigger the `Accept(address indexed applicant);` event on the contract.

The function will be called by the Poll contract when this accounts casts a ballot to it.
```javascript
> comm.isMember("0xe6b032b23bc145ed19e23792e2a107d0794fe65a");
true
```
### Removing Members

```javascript
> comm.remMember.sendTransaction("0xe6b032b23bc145ed19e23792e2a107d0794fe65a",{from:eth.accounts[0], gas: 150000});
"0xab0593239bb538c0822c0289d47f991ed5183b20d25666e73fba7cffaf385c6d"
```
This will trigger the `Remove(address indexed applicant);` event on the contract.
