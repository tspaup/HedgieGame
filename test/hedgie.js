var Hedgie = artifacts.require("Hedgie");

contract('hedgie', function(accounts) {
  it("should assert true", function(done) {
    var hedgie = Hedgie.deployed();
    assert.isTrue(true);
    done();
  });

  it("should return the balance of token owner", function() {
  	var hedgie;
  	return Hedgie.deployed().then(function(instance){
  		hedgie = instance;
  		return hedgie.balanceOf.call(accounts[0]);
  	}).then(function(result){
  		assert.equal(result.toNumber(), 0, 'balance is wrong');
  	})
  });

  it("should return the totalSupply", function() {
  	var hedgie;
  	return Hedgie.deployed().then(function(instance){
  		hedgie = instance;
  		return hedgie.totalSupply.call();
  	}).then(function(result){
  		assert.equal(result.toNumber(), 0, 'totalSupply is wrong');
  	});
  });

  it("should create new token", function(){
  	var hedgie;
  	return Hedgie.deployed().then(function(instance){
  		hedgie = instance;
  		return hedgie.createToken();
  	}).then(function(){
  		return hedgie.createToken();
    }).then(function(){
      return hedgie.createToken();
    }).then(function(){
      return hedgie.createToken();
    }).then(function(){
      return hedgie.createToken();
    }).then(function(){
      return hedgie.createToken();
    }).then(function(){
  		return hedgie.balanceOf.call(accounts[0]);
  	}).then(function(result){
  		assert.equal(result.toNumber(), 6, 'balance is wrong');
  	});
  });

  it("should return token ID from color", function(){
  	var hedgie;
  	return Hedgie.deployed().then(function(instance){
  		hedgie = instance;
      return hedgie.addTokenMetadata(1, '#000000', 2, 5, 7, 8);
    }).then(function(){
  		return hedgie.tokenIdFromColor.call('#000000');
  	}).then(function(result){
      assert.equal(result.toNumber(), 1, 'token ID is wrong');
  	});
  });

  it("should transfer right token", function(){
  	var hedgie;
  	return Hedgie.deployed().then(function(instance){
  		hedgie = instance;
  		return hedgie.transfer(accounts[1], 1);
  	}).then(function(){
  		return hedgie.balanceOf.call(accounts[0]);
  	}).then(function(result){
  		assert.equal(result.toNumber(), 5, 'A balance is wrong');
  		return hedgie.balanceOf.call(accounts[1]);
  	}).then(function(result){
  		assert.equal(result.toNumber(), 1, 'B balance is wrong');
  	});
  });

  it("should give B authority to spend A's token", function(){
  	var hedgie;
  	return Hedgie.deployed().then(function(instance){
  		hedgie = instance;
  		return hedgie.approve(accounts[1], 2);
  	}).then(function(){
  		return hedgie.transferFrom(accounts[0], accounts[2], 2, {from: accounts[1]});
  	}).then(function(){
  		return hedgie.balanceOf.call(accounts[0]);
  	}).then(function(result){
  		assert.equal(result.toNumber(), 4, 'A Balance is wrong');
  		return hedgie.balanceOf.call(accounts[1]);
  	}).then(function(result){
  		assert.equal(result.toNumber(), 1, 'B Balance is wrong');
  		return hedgie.balanceOf.call(accounts[2]);
  	}).then(function(result){
  		assert.equal(result.toNumber(), 1, 'C Balance is wrong');
  	})
  });

  it("should transfer multiple tokens", function(){
    var hedgie;
    var tokens = [];
    return Hedgie.deployed().then(function(instance){
      hedgie = instance;
      tokens.push(3);
      tokens.push(4);
      return hedgie.transferMultiple(accounts[1], tokens);
    }).then(function(){
      return hedgie.balanceOf.call(accounts[0]);
    }).then(function(result){
      assert.equal(result.toNumber(), 2, 'A balance is wrong');
      return hedgie.balanceOf.call(accounts[1]);
    }).then(function(result){
      assert.equal(result.toNumber(), 3, 'B balance is wrong');
    });
  });

  it("should give C authority to spend A's multiple tokens", function(){
    var hedgie;
    return Hedgie.deployed().then(function(instance){
      hedgie = instance;
      return hedgie.approveMultiple(accounts[2], [5,6]);
    }).then(function(){
      return hedgie.transferFromMultiple(accounts[0], accounts[1], [5,6], {from: accounts[2]});
    }).then(function(){
      return hedgie.balanceOf.call(accounts[0]);
    }).then(function(result){
      assert.equal(result.toNumber(), 0, 'A balance is wrong');
    });
  });
});