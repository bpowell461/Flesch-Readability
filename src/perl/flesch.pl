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

sub buildFleschObject {
## Grab the name of the file from the command line, exit if no name given
 my @dalechall = buildHashSet();
 #print "@dalechall"; 
 my $fleschIndex = new flesch(0,0,0,0);
 
 my $filename = $_[0] or die "Need to get file name on the  command line\n";
 
 ## Use the filename 
 open(DATA, "<$filename") or die "Couldn't open file $filename, $!"; 
 
 ##the next line puts all the lines from the text file into an array called @all_lines
 my @all_lines = <DATA>; 
 
 ##Now take each line and break it into tokens based on spaces and print the token
 foreach my $line (@all_lines) {
    my @words = split(' ', $line);
       foreach my $word (@words) {
         #print "$word\n";
            if(isWord($word))
            {
              if(isDifficultWord(@dalechall, $word))
              {
                $fleschIndex->{diffWordCount}++;
              }
              #print "Word to be checked: $word\n";
              $fleschIndex->{wordCount}++;
              $fleschIndex->{syllableCount}+=countSyllables($word);
              foreach my $char (split //, $word)
              {
                if(isSentence($char))
                {
                  $fleschIndex->{sentenceCount}++;
                }
              }
            }
       }
 }
 return $fleschIndex;
}


sub countSyllables {
  my $count = 0;
  my $hasSyllable = 0;
  my $state = "c";
  
  my $word = $_[0];
  my $end = substr($word, -1);
  #print "$word";
  #print "$end";
  if(isSentence($end))
  {
    chomp $word;
    $end = substr($word, -1);
  }
  foreach my $char (split //, $word)
  {
    if($state eq "v")
    {
      if(not(isVowel($char)))
      {
        $hasSyllable = 1;
        $count++;
      }
    }
    $state = isVowel($char)?"v":"c";
  }
  if(($state eq "v") and (not ($end eq "e")) and ($hasSyllable))
  {
    $count++;
  }
  elsif(($state eq "v") and (not($hasSyllable)))
  {
    $count++;
  }
  return ($count);
}

sub isVowel {
  my $char = $_[0];
  $char = lc($char);
  my @vowels = ("a","e","i","o","u","y");
  my %hashmap = map {$_ => 1 } @vowels;
  return (exists($hashmap{$char}));
}

sub isSentence {
  my $char = $_[0];
  ##print "$char";
  my @punctuations = (".",":",";","!","?");
  my %hashmap = map {$_ => 1 } @punctuations;
  return (exists($hashmap{$char}));
}

sub isWord {
  my $word = $_[0];
  $word = lc($word);
  foreach my $char (split //, $word)
  {
  if($char =~ /^[a-z]+$/i)
  {
    return 1;
  } 
  }
  
  return 0;
}

sub isDifficultWord
{
  my @dalechall = $_[0];
  my %hashmap = map {$_ => 1 } @dalechall;
  my $word = $_[1];
  my $end = substr($word, -1);
  print "Checking: $word\n";
  #print "$end";
  if((isSentence($end)) or ($end eq ","))
  {
    chomp $word;
    $end = substr($word, -1);
  }
  return(not(exists($hashmap{$word})));
}

sub buildHashSet
{
  my @dalechall;
  my $filename = "/pub/pounds/CSC330/dalechall/wordlist1995.txt";
  open(DATA, "<$filename") or die "Couldn't open file $filename, $!"; 
  my @all_lines = <DATA>; 
  foreach my $line (@all_lines) {
    my @words = split(' ', $line);
       foreach my $word (@words) {
           #print "Added: $word\n";
           push(@dalechall, $word);
       }
  }
  return @dalechall;
}

  my $fleschIndex=buildFleschObject($ARGV[0]);
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
  print "Sentence Count: $fleschIndex->{sentenceCount}\n";
  print "Word Count: $fleschIndex->{wordCount}\n";
  print("Syllable Count: $fleschIndex->{syllableCount}\n");
  print("\nReadability and Grade Index\n");
  print("-----------------------------------\n");
  print("Flesch Readability Level: $readIndex\n");
  print("Flesch Grade Level Index: $gradeIndex\n");
  print("Dale-Chall Readability Level: $daleIndex\n");