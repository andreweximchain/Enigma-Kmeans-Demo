pragma solidity ^0.4.20;
import "./KMeans.sol";

contract KMeansFactory {
  address public enigmaAddress;
  // List of addresses for deployed KmeansModel instances
  address[] public kMeansModels;

  constructor(address _enigmaAddress) public {
    enigmaAddress = _enigmaAddress;
  }

  // Create a new Kmeansmodel and store the address to an array
  function createNewKmeansModel() public {
    address newKMeansModel = new KMeans(
        enigmaAddress,
        msg.sender
      );
      kMeansModels.push(newKMeansModel);
  }

  //Obtain list of all deployed KmeansModels instances
  function getKMeansModels() public view returns(address[]) {
    return kMeansModels;
  }
}
