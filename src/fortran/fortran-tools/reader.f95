program reader
character(:), allocatable  :: long_string
integer :: filesize

interface
subroutine read_file( string, filesize )
character(:), allocatable :: string
integer :: filesize
end subroutine read_file
end interface

call read_file( long_string, filesize )
!print *, long_string
!print *, "Read ", filesize, " characters."
end program reader

subroutine read_file( string, filesize )
character(len=50) :: cla
!character, dimension(:), allocatable :: string
character(:), allocatable :: string
integer :: counter
integer :: filesize
character (LEN=1) :: input
call get_command_argument(1, cla)

!inquire (file=cla, size=filesize)
open(unit=5,status="old",access="direct",form="unformatted",recl=1,file=cla)
!allocate( string(filesize) )

counter=1
100 read (5,rec=counter,err=200) input
        if(input==' ') then
          print '(A)', "Added", string, " "
          print '(A)'
          string = ""
        else
          string = string//input
        end if
        counter=counter+1
        goto 100
200 continue
counter=counter-1
close (5)
end subroutine read_file

