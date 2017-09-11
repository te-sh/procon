import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto children = new size_t[][](n);
  foreach (i; 1..n) {
    auto parent = readln.chomp.to!size_t-1;
    children[parent] ~= i;
  }

  auto salary = new int[](n);
  foreach_reverse (i; 0..n) {
    if (children[i].empty) {
      salary[i] = 1;
    } else {
      auto salaries = salary.indexed(children[i]);
      salary[i] = salaries.reduce!max + salaries.reduce!min + 1;
    }
  }

  writeln(salary[0]);
}
