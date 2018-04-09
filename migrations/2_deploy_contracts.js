var Hedgie = artifacts.require("./Hedgie.sol");
var Curio = artifacts.require("./Curio.sol");
var HCC = artifacts.require("./HCC.sol");

module.exports = function(deployer){
	deployer.deploy(Hedgie);
	deployer.deploy(Curio);
	deployer.deploy(HCC);
}