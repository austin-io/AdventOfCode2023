#include <iostream>
#include <vector>
#include <sstream>
#include <fstream>
#include <array>

std::array<std::string,10> STRING_INT_KEYS = {
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine"
};

std::vector<std::string> GetInput(){
    std::ifstream inFile("input.txt");

    std::vector<std::string> result;

    while(inFile.good()){
        std::string line = "";
        std::getline(inFile, line);
        result.push_back(line);
    }

    inFile.close();
    return result;
}

int GetFirstDigit_p1(const std::string& line){
    int result = 0;

    for(int i = 0; i < line.size(); i++){
        char c = line[i];
        int value = (int)c - '0';
        if(value >=0 && value <= 9){
            result = value;
            return result;
        }
    }

    return result;
}

int GetLastDigit_p1(const std::string& line){
    int result = 0;

    for(int i = line.size()-1; i >= 0; i--){
        char c = line[i];
        int value = (int)c - '0';
        if(value >=0 && value <= 9){
            result = value;
            return result;
        }
    }

    return result;
}

int StringToIntAtIndex(const std::string& line, int index){
    int result = -1;
    std::string subString = line.substr(index);

    for(int i = 0; i < STRING_INT_KEYS.size(); i++){
        auto idx = subString.find(STRING_INT_KEYS[i]);
        
        if(idx == std::string::npos) continue;
        if(idx == 0) return i;
    }

    return result;
}

int GetFirstDigit_p2(const std::string& line){
    int result = 0;

    for(int i = 0; i < line.size(); i++){
        char c = line[i];
        int value = (int)c - '0';
        if(value >= 0 && value <= 9){
            result = value;
            return result;
        }

        value = StringToIntAtIndex(line, i);
        if(value != -1){
            result = value;
            return result;
        }
    }

    return result;
}

int GetLastDigit_p2(const std::string& line){
    int result = 0;

    for(int i = line.size()-1; i >= 0; i--){
        char c = line[i];
        int value = (int)c - '0';
        if(value >=0 && value <= 9){
            result = value;
            return result;
        }

        value = StringToIntAtIndex(line, i);
        if(value != -1){
            result = value;
            return result;
        }
    }

    return result;
}

void Part1(){
    auto data = GetInput();

    int solution = 0;

    for(auto line : data){
        solution += (GetFirstDigit_p1(line) * 10) + GetLastDigit_p1(line);
    }

    std::cout << solution << std::endl;
}

void Part2(){
    auto data = GetInput();

    int solution = 0;

    for(auto line : data){
        solution += (GetFirstDigit_p2(line) * 10) + GetLastDigit_p2(line);
    }

    std::cout << solution << std::endl;
}

int main(){
    Part1();
    Part2();
}