// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyTwitter {
    address public owner;
    uint16 public MAX_TWEET_LENGTH = 280;
    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }
    mapping (address => Tweet[]) public tweets;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "NOT AUTHORIZED: You are not the contract owner");
        _;
    }

    function changeMaxTweetLength(uint16 length) public onlyOwner {
        MAX_TWEET_LENGTH = length;
    }

    function createTweet(string memory _tweet) public {
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Tweet is too long");

        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        tweets[msg.sender].push(newTweet);
    }

    function getTweet(address _owner, uint16 _index) public view returns (Tweet memory){
        return tweets[_owner][_index];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }

    function likeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "UNAVAILABLE: Tweet does not exist");
        tweets[author][id].likes++;
    }

    function unlikeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "UNAVAILABLE: Tweet does not exist");
        require(tweets[author][id].likes > 0, "BAD REQUEST: There are no likes");
        tweets[author][id].likes--;
    }

}