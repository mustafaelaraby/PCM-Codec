#include <iostream>
#include <regex>
#include <string>

int main()
{
    std::string folderNames[] = {"+Folder1", "Folder2", "+Folder3", "Folder4", "+Folder5"};
    std::regex pattern("^\\+.*");

    for (const std::string &folderName : folderNames)
    {
        if (std::regex_match(folderName, pattern))
        {
            std::cout << "Match found: " << folderName << std::endl;
        }
    }

    return 0;
}
