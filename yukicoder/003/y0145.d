import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto s = readln.chomp;

  int ah, ii, jj, kk, lt, uu, vx, yy, zz;
  foreach (c; s) {
    if      (c <= 'h') ++ah;
    else if (c == 'i') ++ii;
    else if (c == 'j') ++jj;
    else if (c == 'k') ++kk;
    else if (c <= 't') ++lt;
    else if (c == 'u') ++uu;
    else if (c <= 'x') ++vx;
    else if (c == 'y') ++yy;
    else               ++zz;
  }

  auto r = 0;
  while (yy && uu && kk && ii && ah) { ++r; --yy; --uu; --kk; --ii; --ah; }
  while (yy && uu && kk && ii >= 2)  { ++r; --yy; --uu; --kk; ii -= 2; }
  while (yy && uu && kk && jj)       { ++r; --yy; --uu; --kk; --jj; }
  while (yy && uu && kk >= 2)        { ++r; --yy; --uu; kk -= 2; }
  while (yy && uu && lt)             { ++r; --yy; --uu; --lt; }
  while (yy && uu >= 2)              { ++r; --yy; uu -= 2; }
  while (yy && vx)                   { ++r; --yy; --vx; }
  while (yy >= 2)                    { ++r; yy -= 2; }
  while (zz)                         { ++r; --zz; }

  writeln(r);
}
