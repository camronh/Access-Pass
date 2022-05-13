const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AccessPass", function () {
  let accessPassContract, serverContract, owner, accounts;
  it("Deploys", async function () {
    [owner, ...accounts] = await ethers.getSigners();
    const AccessPass = await ethers.getContractFactory("AccessPass");
    accessPassContract = await AccessPass.deploy();
    await accessPassContract.deployed();
    expect(await accessPassContract.totalSupply()).to.equal(0);
    const Server = await ethers.getContractFactory("Server");
    serverContract = await Server.deploy(accessPassContract.address);
    await serverContract.deployed();
    expect(await serverContract.requestsMade()).to.equal(0);
  });
  it("Blocks access", async function () {
    await expect(serverContract.makeRequest(owner.address)).to.be.reverted;
  });
  it("Mints Access Passes", async function () {
    await accessPassContract.buyAccess(accounts[4].address, {
      value: ethers.utils.parseEther(".001"),
    });
    await accessPassContract
      .connect(accounts[1])
      .buyAccess(accounts[4].address, {
        value: ethers.utils.parseEther(".001"),
      });
    expect(await accessPassContract.totalSupply()).to.equal(2);
    expect(
      await accessPassContract.tokenOfOwnerByIndex(accounts[1].address, 0)
    ).to.equal(2);
  });
  it("Blocks Bad requester", async function () {
    await expect(serverContract.makeRequest(accounts[2].address)).to.be
      .reverted;
  });
  it("Set Requester", async function () {
    await accessPassContract.setRequester(owner.address, 1);
    expect(await accessPassContract.requesters(1)).to.equal(owner.address);
  });
  it("Grants Access", async function () {
    await serverContract.makeRequest(owner.address);
    expect(await serverContract.requestsMade()).to.equal(1);
  });
});
