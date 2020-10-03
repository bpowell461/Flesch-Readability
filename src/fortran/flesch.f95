program flesch
implicit none

integer :: filesize
character(len=50) :: cla

interface

subroutine buildFlesch(args, syllableCount, wordCount, sentenceCount, diffWordCount)
  implicit none
  character(:), allocatable :: args
  real, intent(out) :: syllableCount, wordCount, sentenceCount, diffWordCount
  end subroutine buildFlesch
  
function countSyllables(word, syllableCount)
  implicit none
  character(*), intent(in) :: word
  real, intent(inout) :: syllableCount
  end function countSyllables

logical function isVowel(i) result(out)
  implicit none
  character(*), intent(in)  :: i
  end function isVowel
  
logical function isWord(word) result(out)
  implicit none
  character(*), intent(in) :: word
  end function isWord
  
logical function isSentence(i) result(out)
  implicit none
  character(*), intent(in)  :: i
  end function isSentence
  
logical function isDifficultWord(word) result(out)
  implicit none
  character(*), intent(in) :: word
  end function isDifficultWord
  
function checkWord(word)
  implicit none
  character(*), intent(in) :: word
  end function checkWord
  
end interface