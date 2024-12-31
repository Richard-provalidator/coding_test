// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract coding {
    struct student {
        string name;
        uint number;
        uint point;
        string grade;
    }

    student[] students;

    function addStudent(string memory _name, uint _number, uint _point) public  {
        for (uint i=0; i<students.length; i++) 
        {
            if (keccak256(bytes(students[i].name)) == keccak256(bytes(_name))) {
                revert("Student name already exists.");
            }
            if (students[i].number == _number) {
                revert("Student number already exists.");
            }
        }
        
        string memory _grade;

        if (_point >= 90) {
            _grade = "A";
        } else if(_point >= 80) {
              _grade = "B";
        } else if (_point >= 70) {
            _grade = "C";
        } else if (_point >= 60) {
             _grade = "D";
        } else {
             _grade = "F";
        }
        
        students.push(student(_name, _number, _point, _grade));
    }

    function getStudentByNumber(uint _number) public view returns (student memory) {
        return students[_number-1];
    }

    function getStudentByName(string memory _name) public view returns (student memory) {
        student memory s;
        for (uint i=0; i<students.length; i++) 
        {
            if (keccak256(bytes(students[i].name)) == keccak256(bytes(_name))) {
                s = students[i];
                break;
            }
        }
        return s;
    }

    function getPointByName(string memory _name) public view returns (uint) {
        uint _point;
        for (uint i=0; i<students.length; i++) 
        {
            if (keccak256(bytes(students[i].name)) == keccak256(bytes(_name))) {
                _point = students[i].point;
                break;
            }
        }
        return _point;
    }

    function getAllNumber() public view returns(uint[] memory) {
        uint[] memory numbers = new uint[](students.length);
        for (uint i=0; i<students.length; i++) 
        {
            numbers[i] =students[i].number;
        }
        return numbers;
    }

    function getAllStudents() public view returns(student[] memory) {
        student[] memory _students = new student[](students.length);
        for (uint i=0; i<students.length; i++) 
        {
            _students[i] =students[i];
        }
        return _students;
    }

    function getAverage() public view returns (uint) {
        uint sum;
        for (uint i=0; i<students.length; i++) 
        {
            sum +=students[i].point;
        }
        return sum/students.length;
    }

    function evaluationTeacher() public view returns (bool) {
        if (getAverage() >= 70) {
            return true;
        } else {
            return false;
        }
    }

    function getFGrade() public view returns (uint, student[] memory) {
        uint count;
        for (uint i=0; i<students.length; i++) 
        {
            if (keccak256(bytes(students[i].grade)) == keccak256(bytes("F"))) {
                count++;
            }
        }
        student[] memory fGrade = new student[](count);
        uint index;
        for (uint i=0; i<students.length; i++) 
        {
            if (keccak256(bytes(students[i].grade)) == keccak256(bytes("F"))) {
                fGrade[index] = students[i];
                index++;
            }
        }
        return (count, fGrade);
    }

    function getSClass() public view returns (student[4] memory) {
        student[] memory ordered = students;
        for (uint i=0; i<ordered.length; i++) 
        {
            for (uint j=i+1; j < ordered.length; j++) 
            {
                if (ordered[i].point < ordered[j].point) {
                    student memory temp = ordered[i];
                    ordered[i] = ordered[j];
                    ordered[j] = temp;
                }
            }
        }

        student[4] memory sClass;
        for (uint i=0; i<sClass.length; i++) 
        {
            sClass[i] = ordered[i];
        }
        return sClass;
    }
}
