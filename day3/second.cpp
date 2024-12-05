#include <fstream>
#include <iostream>
#include <regex>

int main() {
  std::ifstream file{"input.txt"};
  std::regex mul{R"regex((mul\((\d+),(\d+)\))|(don't\(\).+?do\(\)))regex"};
  std::string s{};
  while (file) {
    std::string line;
    std::getline(file, line);
    s += line;
  }

  std::sregex_iterator begin{s.begin(), s.end(), mul};
  std::sregex_iterator end;

  int sum = 0;
  for (auto it = begin; it != end; ++it) {
    if (!it->str(4).empty())
      continue;

    int a = std::stoi(it->str(2));
    int b = std::stoi(it->str(3));
    sum += a * b;
  }

  std::cout << sum << std::endl;
}
