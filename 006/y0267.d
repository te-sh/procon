import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto c = readln.split;
  writeln(c.sort!((a, b) => a.card < b.card).join(" "));
}

int card(string s)
{
  auto m = s[0].predSwitch('D',0,'C',1,'H',2,'S',3);
  auto n = s[1].predSwitch('A',1,'2',2,'3',3,'4',4,'5',5,'6',6,'7',7,'8',8,'9',9,'T',10,'J',11,'Q',12,'K',13);
  return m * 14 + n;
}
