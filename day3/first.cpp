#include <fstream>
#include <iostream>
#include <regex>
#include <sstream>

int main() {
  std::ifstream file{"input.txt"};
  std::regex mul{R"regex(mul\((\d+),(\d+)\))regex"};

  std::stringstream ss;

  ss << file.rdbuf();

  std::string s = ss.str();

  std::sregex_iterator begin{s.begin(), s.end(), mul};
  std::sregex_iterator end;

  int sum = 0;
  for (auto it = begin; it != end; ++it) {
    int a = std::stoi(it->str(1));
    int b = std::stoi(it->str(2));
    sum += a * b;
  }

  std::cout << sum << std::endl;
}
