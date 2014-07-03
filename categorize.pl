#! /usr/bin/perl

$/ = '\r\n';
#to run perl categorize.pl input_file.txt
my %wordfreq;
my %category = (
                        "Career" => "career_advice.txt",
                        "Relationship" => "relation_advice.txt"
                );
sub tokenize
{
my $input = shift;
open FH, "$input" or die "$input $!";
my $file = <FH>;
chomp($file);
$file =~ s/[[:punct:]]//g;
foreach my $word (split /\s+/,$file)
{
         $word =~ tr/A-Z/a-z/;
         $wordfreq{$word} += 1;
}
close(FH);
return ;
}

sub categorize
{
        my %cat_count;
        my $category = "";
        foreach my $cat (keys %category)
        {
                $cat_count{$cat} = 0;
                open FH1, "$category{$cat}" or die "$category{$cat} $!";
                my $file = <FH1>;
                chomp($file);
                my @lines = split /\n+/,$file;
                foreach my $kword (@lines)
                {
                        chomp($kword);
                        my ($rank, $keyword, $count) = split /  /, $kword;
                        if(exists($wordfreq{$keyword}))
                        {
                                $cat_count{$cat} += $wordfreq{$keyword};
                        }
                }
                close(FH1);
                 }
        #sort hash by values and pick key of one with greatest value
        foreach my $val (sort {$cat_count{$a} <=> $cat_count{$b}} keys %cat_count)
        {
                print "Category: $val Score: $cat_count{$val}\n";
                $category = $val;
        }
                #question - what if more than 1 category have same value?
        return $category;
}

tokenize(shift);
my $category = categorize();
print "Input category: $category\n";

