module myFuncs
implicit none

contains

subroutine buildFlesch(filesize)
  integer::wordCount,syllableCount,sentenceCount,diffWordCount
  real::a, b, aD, readIndex, gradeIndex, dalePercent, daleIndex
  character(len=50) :: cla
  character(:), allocatable :: string
  integer :: counter
  integer :: filesize
  character (LEN=1) :: input
  character(len=20), dimension(2950):: dalechall     !Dalechall list
  character(len=20), dimension(1000000):: bible      !Putting the entire bible into a big array, KJV has ~800,000 words
  integer:: index
  integer:: i
  integer:: j
  !logical:: isVowel, isSentence, isDifficultWord, isWord
  wordCount=0
  syllableCount=0
  sentenceCount=0
  diffWordCount=0
  
  call get_command_argument(1, cla)
  call buildDaleChall(dalechall)
  
  
  !inquire (file=cla, size=filesize)
  open(unit=5,status="old",access="direct",form="unformatted",recl=1,file=cla)
  !allocate( string(filesize) )
  
  counter=1
  index=1
  100 read (5,rec=counter,err=200) input
          if(input==' ' .or. input==char(10)) then                    !Splitting each token based on whitespace or newline
            !print*, string
            bible(index)=string                      !putting tokens into bible array
            index=index+1
            string=""
          else
            string = string//input                  !appending characters
          end if
          counter=counter+1
          goto 100
  200 continue
  counter=counter-1
  close (5)
  
  do i=1, index
    string = bible(i)
    !print*, string
    if(isWord(string)) then
              wordCount=wordCount+1
              string=adjustl(trim(string))    !trimming whitespace on string
                if(isSentence(string))then                
                  sentenceCount=sentenceCount+1
                end if
              string = to_lower(string)
              call checkWord(string)                      !fixing words with brackets
              call countSyllables(string, syllableCount)   !counting syllables
              if(isDifficultWord(dalechall, string)) then
                diffWordCount=diffWordCount+1
              end if
    end if
  end do
  
  
  print*, "Sentence Count: ", sentenceCount
  print*, "Word Count: ", wordCount
  print*, "Syllable Count: ", syllableCount
  print*, "Difficult Word Count: ", diffWordCount
  print*, ""
  a = real(syllableCount)/real(wordCount)
  b = real(wordCount)/real(sentenceCount)
  aD= real(diffWordCount)/real(wordCount)
  
  
  
  
  readIndex = (206.835 - (84.6*a) - (1.015*b))
  gradeIndex= ((11.8*a)+(0.39*b)-15.59)
  dalePercent = aD*100
  daleIndex = (dalePercent*0.1579)+(b*0.0496)
  
  if(dalePercent > 5) then
    daleIndex = daleIndex+3.6365
  end if
  
  
  
  print*, "Readability and Grade Index"
  print*, "-----------------------------------"
  write(*,20) "Flesch Readability Index: ",readIndex
  20 format(a,f3.0)
  !print*, gradeIndex
  write(*,30) "Flesch Grade Level Index: ",gradeIndex
  30 format(a,f3.1)
  !print*, daleIndex
  write(*, 10) "Dale-Chall Readability Index: ", daleIndex
  10 format(a, f3.1)
  
end subroutine buildFlesch
  
  
  
  
  
  
  
  
  
  
  
  
subroutine countSyllables(word, syllableCount)
  character(:), allocatable:: word
  integer :: syllableCount,i,n
  character(1)::end
  character(1)::state
  character(:), allocatable::char
  logical::hasSyllable
  state='c'
  end=word(len(word):)                 !State Machine for syllables: taken from Stack Overflow suggestion
  hasSyllable = .false.
  n=len(word)
  do i=1, n
   char = word(i:i)
   if(state=='v')then
     if(.not. isVowel(word(i:i)))then
       hasSyllable = .true.
       syllableCount=syllableCount+1
       !print*, syllableCount
     end if
   end if
     state = merge('v','c', isVowel(word(i:i)))   !im cool so i used ternary operators
  end do
  if(state == 'v' .and. end /= 'e' .and. hasSyllable) then
    syllableCount = syllableCount+1
  else if(state == 'v' .and. .not. hasSyllable) then
    syllableCount = syllableCount+1
  end if
end subroutine countSyllables









logical function isVowel(char) result(bool)
  character(len=1):: char
  character(LEN=6):: vowels
  integer::pos
  bool = .false.
  vowels = "aeiouy"
  pos = (scan(vowels, char))
  if(pos/=0)then
    bool=.true.
  end if
  !return
end function isVowel











logical function isSentence(char) result(bool)
  character(:), allocatable::char
  character(LEN=5):: punctuations
  integer::pos
  bool = .false.
  punctuations = ".:;!?"
  pos = (scan(punctuations, char))
  if(pos/=0)then
    bool=.true.
  end if
  !return
end function isSentence










logical function isalpha(char)result(bool)
character(:), allocatable::char
character(LEN=52)::alpha
integer::pos
bool = .false.
alpha = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" !Taken
pos = (scan(alpha,char))              !https://web.ics.purdue.edu/~aai/fortref/examples/f77/isalpha.txt
if(pos/=0)then
  bool=.true.
end if
!return
end function isalpha











logical function isWord(word) result(bool)
  character(:), allocatable :: word
  integer:: pos
  bool = .false.
  if(isalpha(word)) then
      bool = .true.
      !return
    end if
  !return
end function isWord











logical function isDifficultWord(dalechall, word) result(bool)
  character(len=20), dimension(2950):: dalechall
  character(:), allocatable:: word
  bool = .false.
  bool = any(dalechall == word)
  bool = .not. bool
  !return
end function isDifficultWord












subroutine checkWord(word)
  character(:), allocatable::word
  integer:: i, n
    if(word(1:1)=="[")then
      word = word(2:)
    end if
    if(word(len(word):)=="]" .or. word(len(word):)=="," .or. isSentence(word))then
      word= word(1:len(word)-1)
    end if
end subroutine checkWord













subroutine buildDaleChall(dalechall)
  character(len=20), dimension(2950):: dalechall
  integer::i,n
  n=2950
  open(unit=5,status="old",file="/pub/pounds/CSC330/dalechall/wordlist1995.txt")
  do i=1, n
  read(*,*) dalechall(i)
  end do 
end subroutine buildDaleChall
function to_lower(in) result(out)
character(*), intent(in)  :: in
character(:), allocatable :: out
integer                   :: i, j

! The following should work with any character set 
character(*), parameter   :: upp = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
character(*), parameter   :: low = 'abcdefghijklmnopqrstuvwxyz'
out = in                                            
do i = 1, LEN_TRIM(out)             
    j = INDEX(upp, out(i:i))        
    if (j > 0) out(i:i) = low(j:j)  
end do

end function to_lower
end module myFuncs
