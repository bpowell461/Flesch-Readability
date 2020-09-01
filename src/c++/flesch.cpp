#include <iostream>
#include <fstream>
#include <sstream>

using namespace std;

int main(int argc, char* argv[])
{
	ifstream file(argv[1]);
	int wordCount = 0;
	string word;
	
	while(file>>word)
	{
		wordCount++;
	}
	cout<<"Word Count: "<<wordCount<<endl;
	file.close();
	return 0;
} 
