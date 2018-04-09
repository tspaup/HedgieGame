var HCC = artifacts.require("HCC");

contract('hcc', function(accounts) {
  it("should assert true", function(done) {
    var hcc = HCC.deployed();
    assert.isTrue(true);
    done();
  });

  it("should return the balance of token owner", function() {
  	var hcc;
  	return HCC.deployed().then(function(instance){
  		hcc = instance;
  		return hcc.balanceOf.call(accounts[0]);
  	}).then(function(result){
  		assert.equal(result.toNumber(), 1000000000000000000000, 'balance is wrong');
  	})
  });

  it("should return total Supply", function() {
    var hcc;
    return HCC.deployed().then(function(instance){
      hcc = instance;
      return hcc.totalSupply.call();
    }).then(function(result){
      assert.equal(result.toNumber(), 1000000000000000000000, 'total Supply is wrong');
    })
  });

  it("should transfer 100 tokens from A to B", function() {
    var hcc;
    return HCC.deployed().then(function(instance){
      hcc = instance;
      return hcc.transfer(accounts[1], 100 * (10 ** 18));
    }).then(function(){
      return hcc.balanceOf.call(accounts[0]);
    }).then(function(result){
      assert.equal(result.toNumber(), 900 * (10**18), 'A balance is wrong');
      return hcc.balanceOf.call(accounts[1]);
    }).then(function(result){
      assert.equal(result.toNumber(), 100 * (10**18), 'B balance is wrong');
    });
  });

  it("should give C authority to spend A's tokens", function() {
    var hcc;
    return HCC.deployed().then(function(instance){
      hcc = instance;
      return hcc.approve(accounts[2], 100 * (10**18));
    }).then(function(){
      return hcc.increaseApproval(accounts[2], 100 * (10**18));
    }).then(function(){
      return hcc.decreaseApproval(accounts[2], 50 * (10**18));
    }).then(function(){
      return hcc.allowance.call(accounts[0], accounts[2]);
    }).then(function(result){
      assert.equal(result.toNumber(), 150 * (10**18), 'allowance value is wrong');
      return hcc.transferFrom(accounts[0], accounts[1], 150 * (10**18), {from: accounts[2]});
    }).then(function(){
      return hcc.balanceOf.call(accounts[0]);
    }).then(function(result){
      assert.equal(result.toNumber(), 750 * (10**18), 'A balance is wrong');
      return hcc.balanceOf.call(accounts[1]);
    }).then(function(result){
      assert.equal(result.toNumber(), 250 * (10**18), 'B balance is wrong');
    });
  });
});