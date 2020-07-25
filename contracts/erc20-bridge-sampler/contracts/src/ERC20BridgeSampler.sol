/*

  Copyright 2019 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity ^0.5.9;
pragma experimental ABIEncoderV2;

import "./CurveSampler.sol";
import "./Eth2DaiSampler.sol";
import "./KyberSampler.sol";
import "./LiquidityProviderSampler.sol";
import "./MultiBridgeSampler.sol";
import "./NativeOrderSampler.sol";
import "./UniswapSampler.sol";
import "./UniswapV2Sampler.sol";
import "./TwoHopSampler.sol";


contract ERC20BridgeSampler is
    Eth2DaiSampler,
    UniswapSampler,
    KyberSampler,
    CurveSampler,
    LiquidityProviderSampler,
    UniswapV2Sampler,
    MultiBridgeSampler,
    NativeOrderSampler,
    TwoHopSampler
{
    /// @dev Call multiple public functions on this contract in a single transaction.
    /// @param callDatas ABI-encoded call data for each function call.
    /// @return callResults ABI-encoded results data for each call.
    function batchCall(bytes[] calldata callDatas)
        external
        view
        returns (bytes[] memory callResults)
    {
        callResults = new bytes[](callDatas.length);
        for (uint256 i = 0; i != callDatas.length; ++i) {
            (bool didSucceed, bytes memory resultData) = address(this).staticcall(callDatas[i]);
            if (!didSucceed) {
                assembly { revert(add(resultData, 0x20), mload(resultData)) }
            }
            callResults[i] = resultData;
        }
    }
}
