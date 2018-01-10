T read1(T)(){return readln.chomp.to!T;}
void read2(S,T)(ref S a,ref T b){auto r=readln.splitter;a=r.front.to!S;r.popFront;b=r.front.to!T;}
void read3(S,T,U)(ref S a,ref T b,ref U c){auto r=readln.splitter;a=r.front.to!S;r.popFront;b=r.front.to!T;r.popFront;c=r.front.to!U;}
void read4(S,T,U,V)(ref S a,ref T b,ref U c,ref V d){auto r=readln.splitter;a=r.front.to!S;r.popFront;b=r.front.to!T;r.popFront;c=r.front.to!U;r.popFront;d=r.front.to!V;r.popFront;}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref ai;a){ai=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref ai; a)ai=readln.chomp.to!T;return a;}
