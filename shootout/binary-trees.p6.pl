# The Computer Language Benchmarks Game
# http://shootout.alioth.debian.org/
#
# Based on the submission for Perl 5.
# Contributed by Bruce Gray (Util)
#
# USAGE: perl6 binary-trees.p6.pl n
#    where n >= 6. The actual shootout uses n=20.
#
# TODO:
#   When :by adverbial modifier is added to Range.pm, change:
#     my $depth = $min_depth; while $depth <= $max_depth { ... $depth += 2; }
#   to:
#     for $min_depth .. $max_depth :by(2) -> $depth { ... }

sub item_check (@tree) {
    return @tree[2] unless defined @tree[0];

    return @tree[2] + item_check( @tree[0] )
                    - item_check( @tree[1] );
}

sub bottom_up_tree ($depth) {
    my @pool = map { [ undef, undef, -$_ ] }, 0 .. 2**$depth-1;

    for reverse( 0 .. ($depth-1) ) -> $exponent {
        for reverse( -(2**$exponent-1) .. 0 ) {
            push @pool, [ @pool.splice(0, 2).reverse, $_ ];
        }
    }
    return @pool[0];
}

sub MAIN ( $n ) {
    my $min_depth = 4;
    my $max_depth = ($min_depth + 2) max $n;

    {
        my $stretch_depth = $max_depth + 1;
        my $stretch_tree = bottom_up_tree($stretch_depth);
        my $check = item_check($stretch_tree);
        say "stretch tree of depth $stretch_depth\t check: $check";
    }

    my $long_lived_tree = bottom_up_tree($max_depth);

    my $depth = $min_depth;
    while $depth <= $max_depth {
        my $iterations = 2 ** ( $max_depth - $depth + $min_depth );
        my $check = 0;

        for 1 .. $iterations -> $i {
            my $temp_tree = bottom_up_tree($depth);
            $check += item_check($temp_tree);

            $temp_tree = bottom_up_tree($depth);
            $check += item_check($temp_tree);
        }

        say $iterations * 2, "\t trees of depth $depth\t check: $check";
        $depth += 2;
    }

    my $long_check = item_check($long_lived_tree);
    say "long lived tree of depth $max_depth\t check: $long_check";
}
