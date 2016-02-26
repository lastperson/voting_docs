
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
```
var web3Provider = 'http://52.28.142.166:8545/';
var web3 = new Web3();
web3.setProvider(new web3.providers.HttpProvider(web3Provider));
```
 
##using registration contract to read a list of polls
```
var fromBlock = 869624;
var regAddress = '0x335d44e65c592110289b9119006af96d0726cd65';
var regAbi = '[{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"owners","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"providers","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"provNames","outputs":[{"name":"","type":"string"}],"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"pollNames","outputs":[{"name":"","type":"string"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"polls","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"pollIndex","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"_poll","type":"address"},{"name":"_name","type":"string"}],"name":"addPoll","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"_provider","type":"address"}],"name":"remProvider","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"provIndex","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"_provider","type":"address"},{"name":"_name","type":"string"}],"name":"addProvider","outputs":[{"name":"","type":"bool"}],"type":"function"},{"inputs":[],"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"provider","type":"address"}],"name":"Provider","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"poll","type":"address"}],"name":"Poll","type":"event"}]';
var regContract = web3.eth.contract($.parseJSON(regAbi)).at(regAddress);
regContract.allEvents({fromBlock: fromBlock, toBlock: 'latest'}, function(err,op) {
  if (op.event === 'Poll') {
    console.log('found poll at address: ' + op.args.poll);
    //read name of poll
    regContract.provIndex(addr, function(error, index) {
      regContract.provNames(index, function(error, name) {
        console.log('poll at address: ' + op.args.poll + 'is named ' + name);
      });
    });
  }
});
```

##using poll contract to read poll details
```
var pollAddress = 'see section "using registration contract to read a list of polls"';
var pollAbi = '[{"constant":false,"inputs":[],"name":"count","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"idVers","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"index","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"_now","type":"uint256"}],"name":"countTimed","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":true,"inputs":[],"name":"questions","outputs":[{"name":"","type":"string"}],"type":"function"},{"constant":false,"inputs":[{"name":"_ballot","type":"uint8[]"},{"name":"_now","type":"uint256"}],"name":"castTimed","outputs":[{"name":"","type":"bytes32"}],"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"},{"name":"_end","type":"uint256"},{"name":"_answerCount","type":"uint8[]"},{"name":"_idVers","type":"address[]"},{"name":"_questions","type":"string"}],"name":"setParams","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"_ballot","type":"uint8[]"}],"name":"cast","outputs":[{"name":"","type":"bytes32"}],"type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"},{"name":"","type":"uint256"}],"name":"results","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"voters","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[],"name":"answersLength","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"answerCount","outputs":[{"name":"","type":"uint8"}],"type":"function"},{"constant":true,"inputs":[],"name":"end","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"},{"name":"","type":"uint256"}],"name":"ballots","outputs":[{"name":"","type":"uint8"}],"type":"function"},{"inputs":[],"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"voter","type":"address"},{"indexed":true,"name":"hash","type":"bytes32"}],"name":"Vote","type":"event"}]';
var pollContract = web3.eth.contract($.parseJSON(window.opt.pollAbi)).at(pollAddress);
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
