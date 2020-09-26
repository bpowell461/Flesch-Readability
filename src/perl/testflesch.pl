#!/usr/bin/perl
use strict;
use warnings;

package flesch;
sub new {
  my $class = shift;
  my $self = {
    syllableCount=>shift,
    wordCount=>shift,
    sentenceCount=> shift,
    diffWordCount=>shift,
    };
    bless $self, $class;
    return $self;
}


  
my @dalechall;
my $dalefilename = "/pub/pounds/CSC330/dalechall/wordlist1995.txt";
open(daleDATA, "<$dalefilename") or die "Couldn't open file $dalefilename, $!"; 
my @d_all_lines = <daleDATA>; 
foreach my $line (@d_all_lines) {
  my @words = split(' ', $line);
     foreach my $word (@words) {
         push(@dalechall, $word);
     }
} 
   
my %hashmap = map {$_ => 1} @dalechall;


my @punctuations = (".",":",";","!","?");
my %puncmap = map {$_ => 1 } @punctuations;

my @vowels = ("a","e","i","o","u","y");
my %vowmap = map {$_ => 1 } @vowels;


my $fleschIndex = new flesch(0,0,0,0); #Flesch Object

my $filename = $ARGV[0] or die "Need to get file name on the  command line\n";
 
## Use the filename 
open(DATA, "<$filename") or die "Couldn't open file $filename, $!"; 

##the next line puts all the lines from the text file into an array called @all_lines
my @all_lines = <DATA>; 
 
##Now take each line and break it into tokens based on spaces and print the token
foreach my $line (@all_lines) 
{
  my @words = split(' ', $line);
  foreach my $word (@words) 
  {
    $word = lc($word);
    
    my $isWord=0;
    
    foreach my $char (split //, $word) #Splitting word into characters
    {
      if($char =~ /^[a-z]+$/i) #Super cool regex checker for alphabet
      {
        $isWord=1;
      } 
    }
    
    
    if($isWord)
    {
    
    
      $fleschIndex->{wordCount}++;
      foreach my $char (split //, $word) #Splitting word into characters
      {
        if(exists($puncmap{$char}))
        {
          $fleschIndex->{sentenceCount}++;
        }
      }
      
      
      my $begin = substr($word, 0, 1);
      my $end = substr($word, -1);
           
      if($begin eq "[") #trimming down words to "natural forms ie. [is] = is ; loved, = loved ; etc.
      {
        $word = substr($word, 1);
      }
      if($end eq "]" or $end eq "," or exists($puncmap{$end}))
      {
        $word = substr($word, 0, -1);
      }
           #print "Word to be checked: $word\n"; #Word being passed into the parameter
      if(not(exists($hashmap{$word})))
      {
        $fleschIndex->{diffWordCount}++;
      }
    
      my $count = 0;
      my $hasSyllable = 0; #boolean to check if word has syllables
      my $state = "c"; #state of state machine
           
      $end = substr($word, -1); #end of word character
                                         
         #Simple state machine inspired by a Stack Overflow answer: https://stackoverflow.com/a/52649782
      foreach my $char (split //, $word) #Splitting word into characters
      {
        if($state eq "v") #Check the state of the machine for vowel 
        {
          if(not(exists($vowmap{$char})))  #Checks for 2 consecutive vowels
          {
            $hasSyllable = 1;
            $fleschIndex->{syllableCount}++;
          }
        }
        $state = (exists($vowmap{$char}))?"v":"c"; #Switching state of the machine
      }
      if(($state eq "v") and (not ($end eq "e")) and ($hasSyllable))#Special case for when the word ends in 'e'
      {
        $fleschIndex->{syllableCount}++;
      }
      elsif(($state eq "v") and (not($hasSyllable))) #Special case for when the word has no syllables
      {
        $fleschIndex->{syllableCount}++;
      }
    }
           
  }
}
   
my $a = ($fleschIndex->{syllableCount})/($fleschIndex->{wordCount});   #
my $b = ($fleschIndex->{wordCount})/($fleschIndex->{sentenceCount});  #Variables used for respective equations
my $aD = ($fleschIndex->{diffWordCount})/($fleschIndex->{wordCount}); #
print("Difficult Word: $fleschIndex->{diffWordCount}\n");

my $readIndex = 206.835-($a*84.6)-($b*1.015);        #Flesch-Readability Index Variable
my $gradeIndex = ($a*11.8)+($b*0.39)-15.59;          #Flesch Grade Level Index
my $dalePercent = ($aD * 100);                      #Dale-Chall Percentage

my $daleIndex =($dalePercent*0.1579)+($b*0.0496);    #Dale-Chall Raw Score
if($dalePercent > 5)
{
  $daleIndex += 3.6365;
}
$readIndex = sprintf("%.0f", $readIndex);
$gradeIndex = sprintf("%.1f", $gradeIndex); #Rounding the numbers
$daleIndex = sprintf("%.1f", $daleIndex);
print "Sentence Count: $fleschIndex->{sentenceCount}\n";
print "Word Count: $fleschIndex->{wordCount}\n";
print("Syllable Count: $fleschIndex->{syllableCount}\n");
print("\nReadability and Grade Index\n");
print("-----------------------------------\n");
print("Flesch Readability Level: $readIndex\n");
print("Flesch Grade Level Index: $gradeIndex\n");
print("Dale-Chall Readability Level: $daleIndex\n");