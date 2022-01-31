module.exports = async function({ ethers, getNamedAccounts, deployments, network }) {
    console.log("network: ", network.name);
    const { deploy } = deployments;
    console.log(`Deployments: `, deploy);

    const { dev, deployer } = await getNamedAccounts();

    const chainId = await getChainId();
    console.log("On chain:", chainId.toString());

    console.log(`Deployer's address: `, deployer);
    console.log(`Dev's address: `, dev);

    if (deployer) {
        const depCollect = await deploy("CODECollection", {
            from: deployer,
            log: true,
            args: ["CODE Collection", "CODE", "https://artion.mypinata.cloud/ipfs/"],
            deterministicDeployment: false,
        });
        console.log("Deployed collection: ", depCollect.address);
        // await deployments.fixture();
        // const collec = await ethers.getContract("CODECollection");
        const collec = await ethers.getContractAt(depCollect.abi, depCollect.address);
        console.log("Collection contract retrieved");
        await collec.addCoder(deployer);
        console.log("Succesfully added coder: ", deployer);
        await collec.addCoder(dev);
        console.log("Succesfully added coder: ", dev);
    } else {
        console.log("Didn't get any deployer");
    }
};

module.exports.tags = ["CODECollection"];