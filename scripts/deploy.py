from brownie import AssetTracker, Synth, PriceFeed, Staker, accounts
import os 


def main():
    onx = os.environ.get('onx',None)
    if  onx:
        from_det = {'from': accounts[0]}
        # asset tracket
        print('deploying Asset tracker')
        at = AssetTracker.deploy(from_det)
        # synth 
        print('deploying susd')
        SUSD = Synth.deploy('SUSD', 'sUSD','','',0, at.address,from_det)
        # price feed
        print('deploying price feed')
        pf = PriceFeed.deploy(from_det)
        # staker
        print('deploying staker')
        staker = Staker.deploy(onx, pf.address, at.address, from_det)
        print("using onx",onx)
        return True
    print("onx not found")
    return False
