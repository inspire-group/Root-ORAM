#ifndef TEST_H__
#define TEST_H__

#include <map>
#include <fstream>
#include <cmath>
#include <string>
#include <cstdlib>
using std::cout;
using std::endl;
using std::map;
using std::string;

#define TRIALS 500000.0

void pruint64_t(long long i, map<long long, long long >& m2, string filename, int varI, double epsilon)
{
   system("mkdir -p res");
   // filename = "res/"+filename+"_"+std::to_string(bucket_size);
   filename = "res/"+filename;
   cout << i <<" "<< filename << endl;
   std::ofstream fout(filename, std::ofstream::out | std::ofstream::app);

   int maximum = 0;
   long expected = 0;
   for(auto & v:m2)
   {
      expected += v.first * v.second;
      if (v.first > maximum) { maximum = v.first; }
   }
   fout << varI << ' ' << epsilon << ' ' << expected/TRIALS << ' ' << maximum << endl;
   fout.close();
}
#endif// TEST_H__
