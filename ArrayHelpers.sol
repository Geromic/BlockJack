contract ArrayHelpers{
        
    function concatenateArrays(uint8[] memory firstArray, uint8[] memory secondArray) internal pure returns(uint8[] memory) {
        uint8[] memory returnArr = new uint8[](firstArray.length + secondArray.length);
    
        uint i=0;
        for (; i < firstArray.length; i++) {
            returnArr[i] = firstArray[i];
        }
    
        uint j=0;
        while (j < firstArray.length) {
            returnArr[i++] = secondArray[j++];
        }
    
        return returnArr;
    }
}