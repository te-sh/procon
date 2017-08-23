import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto ra = readln.split, na = ra[0], pa = ra[1], la = pa.length;
  auto rb = readln.split, nb = rb[0], pb = rb[1], lb = pb.length;

  if (la > lb) pb = pb.rightJustify(la, '0');
  if (la < lb) pa = pa.rightJustify(lb, '0');

  if (pa > pb)
    writeln(na);
  else if (pa < pb)
    writeln(nb);
  else
    writeln(-1);
}
