program flesch
implicit none
integer :: filesize


interface

subroutine buildFlesch(filesize)
  implicit none
  integer :: filesize
  end subroutine buildFlesch
  
subroutine countSyllables(word, syllableCount)
  implicit none
  character(:), allocatable, intent(in)::word
  integer, intent(inout) :: syllableCount
  end subroutine countSyllables

logical function isVowel(char) result(bool)
  implicit none
  character(len=1), intent(in)::char
  !logical::bool
  end function isVowel
  
logical function isalpha(char) result(bool)
  implicit none
  character(len=1), intent(in)::char
  !logical::bool
  end function isalpha
  
logical function isWord(word) result(bool)
  implicit none
  character(:), allocatable, intent(in)::word
  !logical::bool
  end function isWord
  
logical function isSentence(char) result(bool)
  implicit none
  character(len=1), intent(in)::char
  !logical::bool
  end function isSentence
  
logical function isDifficultWord(dalechall, word) result(bool)
  implicit none
  character(:), dimension(763), allocatable, intent(in)::dalechall
  character(:), allocatable, intent(in)::word
  !logical::bool
  end function isDifficultWord
  
subroutine checkWord(word)
  implicit none
  character(:), allocatable, intent(inout)::word
  end subroutine checkWord
  
end interface


call buildFlesch(filesize)

end program flesch

subroutine buildFlesch(filesize)
  implicit none
  integer::wordCount,syllableCount,sentenceCount,diffWordCount
  real::a, b, aD, readIndex, gradeIndex, dalePercent, daleIndex
  character(len=50) :: cla
  character(:), allocatable :: string
  integer :: counter
  integer :: filesize
  character (LEN=1) :: input
  !logical:: isVowel, isSentence, isDifficultWord, isWord
  wordCount=0
  syllableCount=0
  sentenceCount=0
  diffWordCount=0
  
  call get_command_argument(1, cla)

  !inquire (file=cla, size=filesize)
  open(unit=5,status="old",access="direct",form="unformatted",recl=1,file=cla)
  !allocate( string(filesize) )

  counter=1
  100 read (5,rec=counter,err=200) input
          if(input==' ') then
            
            if(isWord(string)) then
            
              wordCount=wordCount+1
              
                if(isSentence(input))then
                  sentenceCount=sentenceCount+1
                end if
              
              call checkWord(string)
              
              if(isDifficultWord(string)) then
                diffWordCount=diffWordCount+1
              end if
              
              
              call countSyllables(string, syllableCount)
              
            end if
            string=""
            
            
          else
            string = string//input
          end if
          
          counter=counter+1
          goto 100
  200 continue
  counter=counter-1
  close (5)
  
  print*, "Syllable Count ", syllableCount
  print*, "Word Count ", wordCount
  print*, "Sentence Count ", sentenceCount
  
  a = real(syllableCount)/real(wordCount)
  b = real(wordCount)/real(sentenceCount)
  aD= real(diffWordCount)/real(sentenceCount)
  
  readIndex = (206.835 - (84.6*a) - (1.015*b))
  gradeIndex= ((11.8*a)+(0.39*b)-15.59)
  dalePercent = aD*100
  daleIndex = (dalePercent*0.1579)+(b*0.0496)
  
  if(dalePercent > 5) then
    daleIndex = daleIndex+3.6365
  end if
  
  write(*,20) "Flesch: ",flesch
  20 format(a,i3)

  write(*,30) "FleschKincaid: ",fkincaid
  30 format(a,f3.1)
  
  write(*, 40) "DaleChall: ", daleIndex
  40 format(a, f3.1)
  
end subroutine buildFlesch
  
subroutine countSyllables(word, syllableCount)
  implicit none
  character(:), allocatable:: word
  integer :: syllableCount
  character(1)::end
  character(1)::state
  logical::hasSyllable
  
  state='c'
  end=word(len(word):)
  do i=1, n
   select case (state)
     case('c')
     
     case('v')
       if(.not. isVowel(word(i:i))) then
         hasSyllable = .true.
         syllableCount = syllableCount+1
       end if
     end select
     state = merge('v','c', isVowel(word(i:i)))
  end do
  if(state == 'v' .and. end /= 'e' .and. hasSyllable) then
    syllableCount = syllableCount+1
  else if(state == 'v' .and. hasSyllable .eqv. .false.) then
    syllableCount = syllableCount+1
  end if
end subroutine countSyllables

logical function isVowel(char) result(bool)
  implicit none
  character(len=1):: char
  character(LEN=6):: vowels
  !logical::bool
  integer:: pos
  vowels = "aeiouy"
  pos = (index(vowels, char))
  if(pos/=0)then
    bool=.true.
  else
    bool=.false.
  end if
  !return
end function isVowel

logical function isSentence(char) result(bool)
  implicit none
  character(len=1):: char
  character(LEN=5):: punctuations
  !logical::bool
  integer:: pos
  punctuations = ".:;!?"
  pos = (index(punctuations, char))
  if(pos/=0)then
    bool=.true.
  else
    bool=.false.
  end if
  !return
end function isSentence

logical function isalpha(char)result(bool)
implicit none
character(LEN=1)::char
character(LEN=52)::alpha
!logical::bool
integer::pos
alpha = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" !Taken from 
pos = (index(alpha,char)) !https://web.ics.purdue.edu/~aai/fortref/examples/f77/isalpha.txt
if(pos/=0)then
  bool=.true.
else
  bool=.false.
end if
!return
end function isalpha

logical function isWord(word) result(bool)
  implicit none
  character(:), allocatable :: word
  do i=1, n
    if(isalpha(word(i:i))) then
      bool = .true.
      !return
    end if
  end do
  bool = .false.
  !return
end function isWord

logical function isDifficultWord(dalechall, word) result(bool)
  implicit none
  character(:), dimension(763), allocatable :: dalechall
  character(:), allocatable:: word
  bool = any(dalechall == word)
  !return
end function isDifficultWord

subroutine checkWord(word)
  implicit none
  character(:), allocatable::word
  do i=1, n
    if(word(1:1)=="[")then
      word = word(2:)
    end if
    if(word(len(word):)=="]" .or. word(len(word):)=="," .or. isSentence(word(len(word):)))then
      word= word(1:len(word)-1)
    end if
  end do
end subroutine checkWord

  