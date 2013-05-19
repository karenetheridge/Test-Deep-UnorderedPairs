use strict;
use warnings;
package Test::Deep::UnorderedPairs;
# ABSTRACT: ...

use parent 'Test::Deep::Cmp';
use Exporter 'import';
use Carp 'confess';
use Test::Deep::Hash;

# I'm not sure what name is best; decide later
our @EXPORT = qw(tuples unordered_pairs);

sub tuples
{
    return __PACKAGE__->new(@_);
}
sub unordered_pairs { goto &tuples }

sub init
{
    my ($self, @vals) = @_;

    confess 'tuples must have an even number of elements'
        if @vals % 2;

    $self->{val_as_hash} = Test::Deep::Hash->new({ @vals });
}

sub descend
{
    my ($self, $got) = @_;

    return 0 unless $self->test_reftype($got, 'ARRAY');

    # simply compare as a hashref
    my $exp = $self->{val_as_hash};

    if ($exp->descend( { @$got } ))
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

...

=head1 DESCRIPTION


=head1 FUNCTIONS/METHODS

=begin :list

* C<foo>

=end :list

...

=head1 SUPPORT

=for stopwords irc

Bugs may be submitted through L<the RT bug tracker|https://rt.cpan.org/Public/Dist/Display.html?Name=Test-Deep-UnorderedPairs>
(or L<bug-Test-Deep-UnorderedPairs@rt.cpan.org|mailto:bug-Test-Deep-UnorderedPairs@rt.cpan.org>).
I am also usually active on irc, as 'ether' at C<irc.perl.org>.

=head1 ACKNOWLEDGEMENTS

...

=head1 SEE ALSO

...

=cut
