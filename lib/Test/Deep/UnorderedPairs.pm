use strict;
use warnings;
package Test::Deep::UnorderedPairs;
# ABSTRACT: A Test::Deep plugin for comparing lists as if they were hashes

use parent 'Test::Deep::Cmp';
use Exporter 'import';
use Carp 'confess';
use Test::Deep::Hash;
use Test::Deep::ArrayLength;

# I'm not sure what name is best; decide later
our @EXPORT = qw(tuples unordered_pairs samehash);

sub tuples
{
    return __PACKAGE__->new(@_);
}
sub unordered_pairs { goto &tuples }
sub samehash { goto &tuples }

sub init
{
    my ($self, @vals) = @_;

    confess 'tuples must have an even number of elements'
        if @vals % 2;

    $self->{val} = \@vals;
}

sub descend
{
    my ($self, $got) = @_;

    my $exp = $self->{val};

    return 0 unless Test::Deep::ArrayLength->new(@$exp + 0)->descend($got);

    # simply compare as a hashref
    if (Test::Deep::Hash->new({ @{$self->{val}} })->descend( { @$got } ))
    {
        $Test::Deep::Stack->pop;
        return 1;
    }
    return 0;
}

1;
__END__

=pod

=head1 SYNOPSIS

    use Test::More;
    use Test::Deep;
    use Test::Deep::UnorderedPairs;

    cmp_deeply(
        {
            inventory => [
                pear => 6,
                peach => 5,
                apple => 1,
            ],
        },
        {
            inventory => unordered_pairs(
                apple => 1,
                peach => ignore,
                pear => 6,
            ),
        },
        'got the right inventory',
    );

=head1 DESCRIPTION

This module provides the sub C<unordered_pairs>
(and C<tuples>, C<samehash>, as synonyms)
to indicate the data being tested is a list of pairs that should be tested
where the order of the pairs is insignificant.

This is useful when testing a function that returns a list of hash elements as
an arrayref, not a hashref.  One such application might be testing L<PSGI>
headers, which are passed around as an arrayref:

    my $response = [
        '200',
        [
            'Content-Length' => '12',
            'Content-Type' => 'text/plain',
        ],
        [ 'hello world!' ],
    ];

    # this test passes
    cmp_deeply(
        $response,
        [
            '200',
            unordered_pairs(
                'Content-Type' => 'text/plain',
                'Content-Length' => '12',
            ],
            [ 'hello world!' ],
        ],
        'check headers as an arrayref of unordered pairs',
    );

=head1 FUNCTIONS/METHODS

=for stopwords tuples

=for Pod::Coverage
init
descend

=over

=item * C<unordered_pairs>

Pass an (even-numbered) list of items to test

=item * C<tuples>, C<samehash>

C<tuples> and C<samehash> are aliases for C<unordered_pairs>.  I'm open to more names as well;
I'm not quite yet sure what the best nomenclature should be.

=back

=head1 SUPPORT

=for stopwords irc

Bugs may be submitted through L<the RT bug tracker|https://rt.cpan.org/Public/Dist/Display.html?Name=Test-Deep-UnorderedPairs>
(or L<bug-Test-Deep-UnorderedPairs@rt.cpan.org|mailto:bug-Test-Deep-UnorderedPairs@rt.cpan.org>).
I am also usually active on irc, as 'ether' at C<irc.perl.org>.

=head1 ACKNOWLEDGEMENTS

Ricardo Signes, for maintaining L<Test::Deep> and for being the first consumer
of this module, in L<Router::Dumb>.

=head1 SEE ALSO

L<Test::Deep>

=cut
