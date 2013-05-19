# NAME

Test::Deep::UnorderedPairs - A Test::Deep plugin for comparing lists as if they were hashes

# VERSION

version 0.001

# SYNOPSIS

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

# DESCRIPTION

This module provides the sub `unordered_pairs` (and `tuples`, as a synonym)
to indicate the data being tested is a list of pairs that should be tested
where the order of the pairs is insignificant.  This would be equivalent to
testing the list is as if it were a hash.

This is useful when testing a function that returns a list of hash elements as
an arrayref, not a hashref.  One such application might be testing [PSGI](http://search.cpan.org/perldoc?PSGI)
headers, which are passed around as an arrayref:

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

# FUNCTIONS/METHODS

- `unordered_pairs`

    Pass an (even-numbered) list of items to test

- `tuples`, `samehash`

    `tuples` and `samehash` are aliases for `unordered_pairs`.  I'm open to more names as well;
    I'm not quite yet sure what the best nomenclature should be.

# SUPPORT

Bugs may be submitted through [the RT bug tracker](https://rt.cpan.org/Public/Dist/Display.html?Name=Test-Deep-UnorderedPairs)
(or [bug-Test-Deep-UnorderedPairs@rt.cpan.org](mailto:bug-Test-Deep-UnorderedPairs@rt.cpan.org)).
I am also usually active on irc, as 'ether' at `irc.perl.org`.

# ACKNOWLEDGEMENTS

Ricardo Signes, for maintaining [Test::Deep](http://search.cpan.org/perldoc?Test::Deep) and for being the first consumer
of this module, in [Router::Dumb](http://search.cpan.org/perldoc?Router::Dumb).

# SEE ALSO

[Test::Deep](http://search.cpan.org/perldoc?Test::Deep)

# AUTHOR

Karen Etheridge <ether@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Karen Etheridge.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
