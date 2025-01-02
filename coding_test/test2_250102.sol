// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract coding {
    struct student {
        uint number;
        string name;
        uint score;
    }

    student[] public students;

    function lowestScore() public view returns (student memory) {
        uint min = type(uint).max;
        uint index;

        for(uint i=0; i<students.length; i++) {
            if(students[i].score <= min) {
                min = students[i].score;
                index = i;
            }
        }

        return students[index];
    }

    function getSumAndAverage() public view returns (uint, uint) {
        uint sum;
        for (uint i=0; i<students.length; i++) 
        {
            sum +=students[i].score;
        }
        return (sum, sum/students.length);
    }

    function getStudentByNumber(uint _number) public view returns (student memory) {
        return students[_number-1];
    }

    function getAllStudents() public view returns(student[] memory) {
        return students;
    }
}
