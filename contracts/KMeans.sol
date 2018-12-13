pragma solidity 0.4.24;

contract KMeans {
    address public owner;
    address public enigma;

    event CallbackFinished();

    	// Modifier to ensure only enigma contract can call function
    	modifier onlyEnigma() {
    		require(msg.sender == enigma);
    		_;
    	}

    constructor(address _enigmaAddress, address _owner) public {
      owner = _owner;
      enigma = _enigmaAddress;
    }
    int256[] public centroid;
    uint256 public vectorLength;
    uint256 public nCentroids;
    int256[][] public centroids;

    function sqrt(uint x) returns (uint y) {
      if (x == 0) return 0;
      else if (x <= 3) return 1;
      uint z = (x + 1) / 2;
      y = x;
      while (z < y)
      {
        y = z;
        z = (x / z + z) / 2;
      }
    }
    //Callable function for the sgx to run.
    //Because we do not have access to floats decimal values should be padded
    //by an amount specified by the sgx machine to increase accuracy.
    function predict(int[] _inputVector) public returns (uint centroid_id) {
      uint shortest_distance;
      centroid_id = 0;
      for(uint cid = 0; cid < nCentroids; cid ++) {
        int sqr_distance = 0;
        for (uint vid = 0; vid < vectorLength; vid++){
          sqr_distance = sqr_distance + ((centroids[cid][vid]-_inputVector[vid])*(centroids[cid][vid]-_inputVector[vid]));
        }
        uint distance = sqrt(uint(sqr_distance));
        if(cid == 0){
          shortest_distance = distance;
        }else{
          if(shortest_distance > distance){
            shortest_distance = distance;
            centroid_id = cid;
          }
        }
      }
    }
    //long array of integers number of centroids will be determined by how long
    //the the vectorarray, vector length should always be divisible by
    //the centroidArray length. Thus the centroidArray.length/vectorlength will
    //be the number of centroids.
    function setCentroid(int[] _centroidArray, uint _vectorLength) public onlyEnigma() {
      //check to insure vectorLength and centroid array makes sense
      require(_centroidArray.length % _vectorLength == 0);
      vectorLength = _vectorLength;
      nCentroids = _centroidArray.length / _vectorLength;
      uint n = 0;
      for(uint cid = 0; cid < nCentroids; cid ++){
        for(uint i = 0; i < _vectorLength; i ++){
          centroids[cid][i] = _centroidArray[n];
          n = n + 1;
        }
      }
    }

    uint public centroidID;
    //callback for the sgx to call
    function setClosestCentroid(uint _centroidID) public onlyEnigma() {
      centroidID = _centroidID;
      emit CallbackFinished();
    }


}
