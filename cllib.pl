=head1 NAME
 
perlvar - Perl predefined variables
 
=head1 DESCRIPTION
 
=head2 The Syntax of Variable Names
 
Variable names in Perl can have several formats.  Usually, they
must begin with a letter or underscore, in which case they can be
arbitrarily long (up to an internal limit of 251 characters) and
may contain letters, digits, underscores, or the special sequence
C<::> or C<'>.  In this case, the part before the last C<::> or
C<'> is taken to be a I<package qualifier>; see L<perlmod>.
A Unicode letter that is not ASCII is not considered to be a letter
unless S<C<"use utf8">> is in effect, and somewhat more complicated
rules apply; see L<perldata/Identifier parsing> for details.
 
Perl variable names may also be a sequence of digits, a single
punctuation character, or the two-character sequence: C<^> (caret or
CIRCUMFLEX ACCENT) followed by any one of the characters C<[][A-Z^_?\]>.
These names are all reserved for
special uses by Perl; for example, the all-digits names are used
to hold data captured by backreferences after a regular expression
match.
 
Since Perl v5.6.0, Perl variable names may also be alphanumeric strings
preceded by a caret.  These must all be written using the demarcated
variable form using curly braces such as C<${^Foo}>;
the braces are B<not> optional.  C<${^Foo}> denotes the scalar variable
whose name is considered to be a control-C<F> followed by two C<o>'s.
(See L<perldata/"Demarcated variable names using braces"> for more
information on this form of spelling a variable name or specifying
access to an element of an array or a hash).
These variables are
reserved for future special uses by Perl, except for the ones that
begin with C<^_> (caret-underscore).  No
name that begins with C<^_> will acquire a special
meaning in any future version of Perl; such names may therefore be
used safely in programs.  C<$^_> itself, however, I<is> reserved.
 
Note that you also B<must> use the demarcated form to access subscripts
of variables of this type when interpolating, for instance to access the
first element of the C<@{^CAPTURE}> variable inside of a double quoted
string you would write C<"${^CAPTURE[0]}"> and NOT C<"${^CAPTURE}[0]">
which would mean to reference a scalar variable named C<${^CAPTURE}> and
not index 0 of the magic C<@{^CAPTURE}> array which is populated by the
regex engine.
 
Perl identifiers that begin with digits or
punctuation characters are exempt from the effects of the C<package>
declaration and are always forced to be in package C<main>; they are
also exempt from C<strict 'vars'> errors.  A few other names are also
exempt in these ways:
 
    ENV      STDIN
    INC      STDOUT
    ARGV     STDERR
    ARGVOUT
    SIG
 
In particular, the special C<${^_XYZ}> variables are always taken
to be in package C<main>, regardless of any C<package> declarations
presently in scope.
 
=head1 SPECIAL VARIABLES
 
The following names have special meaning to Perl.  Most punctuation
names have reasonable mnemonics, or analogs in the shells.
Nevertheless, if you wish to use long variable names, you need only say:
 
    use English;
 
at the top of your program.  This aliases all the short names to the long
names in the current package.  Some even have medium names, generally
borrowed from B<awk>.  For more info, please see L<English>.
 
Before you continue, note the sort order for variables.  In general, we
first list the variables in case-insensitive, almost-lexigraphical
order (ignoring the C<{> or C<^> preceding words, as in C<${^UNICODE}>
or C<$^T>), although C<$_> and C<@_> move up to the top of the pile.
For variables with the same identifier, we list it in order of scalar,
array, hash, and bareword.
 
=head2 General Variables
 
=over 8
 
=item $ARG
 
=item $_
X<$_> X<$ARG>
 
The default input and pattern-searching space.  The following pairs are
equivalent:
 
    while (<>) {...}    # equivalent only in while!
    while (defined($_ = <>)) {...}
 
    /^Subject:/
    $_ =~ /^Subject:/
 
    tr/a-z/A-Z/
    $_ =~ tr/a-z/A-Z/
 
    chomp
    chomp($_)
 
Here are the places where Perl will assume C<$_> even if you don't use it:
 
=over 3
 
=item *
 
The following functions use C<$_> as a default argument:
 
abs, alarm, chomp, chop, chr, chroot,
cos, defined, eval, evalbytes, exp, fc, glob, hex, int, lc,
lcfirst, length, log, lstat, mkdir, oct, ord, pos, print, printf,
quotemeta, readlink, readpipe, ref, require, reverse (in scalar context only),
rmdir, say, sin, split (for its second
argument), sqrt, stat, study, uc, ucfirst,
unlink, unpack.
 
=item *
 
All file tests (C<-f>, C<-d>) except for C<-t>, which defaults to STDIN.
See L<perlfunc/-X>
 
=item *
 
The pattern matching operations C<m//>, C<s///> and C<tr///> (aka C<y///>)
when used without an C<=~> operator.
 
=item *
 
The default iterator variable in a C<foreach> loop if no other
variable is supplied.
 
=item *
 
The implicit iterator variable in the C<grep()> and C<map()> functions.
 
=item *
 
The implicit variable of C<given()>.
 
=item *
 
The default place to put the next value or input record
when a C<< <FH> >>, C<readline>, C<readdir> or C<each>
operation's result is tested by itself as the sole criterion of a C<while>
test.  Outside a C<while> test, this will not happen.
 
=back
 
C<$_> is a global variable.
 
However, between perl v5.10.0 and v5.24.0, it could be used lexically by
writing C<my $_>.  Making C<$_> refer to the global C<$_> in the same scope
was then possible with C<our $_>.  This experimental feature was removed and is
now a fatal error, but you may encounter it in older code.
 
Mnemonic: underline is understood in certain operations.
 
=item @ARG
 
=item @_
X<@_> X<@ARG>
 
Within a subroutine the array C<@_> contains the parameters passed to
that subroutine.  Inside a subroutine, C<@_> is the default array for
the array operators C<pop> and C<shift>.
 
See L<perlsub>.
 
=item $LIST_SEPARATOR
 
=item $"
X<$"> X<$LIST_SEPARATOR>
 
When an array or an array slice is interpolated into a double-quoted
string or a similar context such as C</.../>, its elements are
separated by this value.  Default is a space.  For example, this:
 
    print "The array is: @array\n";
 
is equivalent to this:
 
    print "The array is: " . join($", @array) . "\n";
 
Mnemonic: works in double-quoted context.
 
=item $PROCESS_ID
 
=item $PID
 
=item $$
X<$$> X<$PID> X<$PROCESS_ID>
 
The process number of the Perl running this script.  Though you I<can> set
this variable, doing so is generally discouraged, although it can be
invaluable for some testing purposes.  It will be reset automatically
across C<fork()> calls.
 
Note for Linux and Debian GNU/kFreeBSD users: Before Perl v5.16.0 perl
would emulate POSIX semantics on Linux systems using LinuxThreads, a
partial implementation of POSIX Threads that has since been superseded
by the Native POSIX Thread Library (NPTL).
 
LinuxThreads is now obsolete on Linux, and caching C<getpid()>
like this made embedding perl unnecessarily complex (since you'd have
to manually update the value of $$), so now C<$$> and C<getppid()>
will always return the same values as the underlying C library.
 
Debian GNU/kFreeBSD systems also used LinuxThreads up until and
including the 6.0 release, but after that moved to FreeBSD thread
semantics, which are POSIX-like.
 
To see if your system is affected by this discrepancy check if
C<getconf GNU_LIBPTHREAD_VERSION | grep -q NPTL> returns a false
value.  NTPL threads preserve the POSIX semantics.
 
Mnemonic: same as shells.
 
=item $PROGRAM_NAME
 
=item $0
X<$0> X<$PROGRAM_NAME>
 
Contains the name of the program being executed.
 
On some (but not all) operating systems assigning to C<$0> modifies
the argument area that the C<ps> program sees.  On some platforms you
may have to use special C<ps> options or a different C<ps> to see the
changes.  Modifying the C<$0> is more useful as a way of indicating the
current program state than it is for hiding the program you're
running.
 
Note that there are platform-specific limitations on the maximum
length of C<$0>.  In the most extreme case it may be limited to the
space occupied by the original C<$0>.
 
In some platforms there may be arbitrary amount of padding, for
example space characters, after the modified name as shown by C<ps>.
In some platforms this padding may extend all the way to the original
length of the argument area, no matter what you do (this is the case
for example with Linux 2.2).
 
Note for BSD users: setting C<$0> does not completely remove "perl"
from the ps(1) output.  For example, setting C<$0> to C<"foobar"> may
result in C<"perl: foobar (perl)"> (whether both the C<"perl: "> prefix
and the " (perl)" suffix are shown depends on your exact BSD variant
and version).  This is an operating system feature, Perl cannot help it.
 
In multithreaded scripts Perl coordinates the threads so that any
thread may modify its copy of the C<$0> and the change becomes visible
to ps(1) (assuming the operating system plays along).  Note that
the view of C<$0> the other threads have will not change since they
have their own copies of it.
 
If the program has been given to perl via the switches C<-e> or C<-E>,
C<$0> will contain the string C<"-e">.
 
On Linux as of perl v5.14.0 the legacy process name will be set with
C<prctl(2)>, in addition to altering the POSIX name via C<argv[0]> as
perl has done since version 4.000.  Now system utilities that read the
legacy process name such as ps, top and killall will recognize the
name you set when assigning to C<$0>.  The string you supply will be
cut off at 16 bytes, this is a limitation imposed by Linux.
 
Wide characters are invalid in C<$0> values. For historical reasons,
though, Perl accepts them and encodes them to UTF-8. When this
happens a wide-character warning is triggered.
 
Mnemonic: same as B<sh> and B<ksh>.
 
=item $REAL_GROUP_ID
 
=item $GID
 
=item $(
X<$(> X<$GID> X<$REAL_GROUP_ID>
 
The real gid of this process.  If you are on a machine that supports
membership in multiple groups simultaneously, gives a space separated
list of groups you are in.  The first number is the one returned by
C<getgid()>, and the subsequent ones by C<getgroups()>, one of which may be
the same as the first number.
 
However, a value assigned to C<$(> must be a single number used to
set the real gid.  So the value given by C<$(> should I<not> be assigned
back to C<$(> without being forced numeric, such as by adding zero.  Note
that this is different to the effective gid (C<$)>) which does take a
list.
 
You can change both the real gid and the effective gid at the same
time by using C<POSIX::setgid()>.  Changes
to C<$(> require a check to C<$!>
to detect any possible errors after an attempted change.
 
Mnemonic: parentheses are used to I<group> things.  The real gid is the
group you I<left>, if you're running setgid.
 
=item $EFFECTIVE_GROUP_ID
 
=item $EGID
 
=item $)
X<$)> X<$EGID> X<$EFFECTIVE_GROUP_ID>
 
The effective gid of this process.  If you are on a machine that
supports membership in multiple groups simultaneously, gives a space
separated list of groups you are in.  The first number is the one
returned by C<getegid()>, and the subsequent ones by C<getgroups()>,
one of which may be the same as the first number.
 
Similarly, a value assigned to C<$)> must also be a space-separated
list of numbers.  The first number sets the effective gid, and
the rest (if any) are passed to C<setgroups()>.  To get the effect of an
empty list for C<setgroups()>, just repeat the new effective gid; that is,
to force an effective gid of 5 and an effectively empty C<setgroups()>
list, say C< $) = "5 5" >.
 
You can change both the effective gid and the real gid at the same
time by using C<POSIX::setgid()> (use only a single numeric argument).
Changes to C<$)> require a check to C<$!> to detect any possible errors
after an attempted change.
 
C<< $< >>, C<< $> >>, C<$(> and C<$)> can be set only on
machines that support the corresponding I<set[re][ug]id()> routine.  C<$(>
and C<$)> can be swapped only on machines supporting C<setregid()>.
 
Mnemonic: parentheses are used to I<group> things.  The effective gid
is the group that's I<right> for you, if you're running setgid.
 
=item $REAL_USER_ID
 
=item $UID
 
=item $<
X<< $< >> X<$UID> X<$REAL_USER_ID>
 
The real uid of this process.  You can change both the real uid and the
effective uid at the same time by using C<POSIX::setuid()>.  Since
changes to C<< $< >> require a system call, check C<$!> after a change
attempt to detect any possible errors.
 
Mnemonic: it's the uid you came I<from>, if you're running setuid.
 
=item $EFFECTIVE_USER_ID
 
=item $EUID
 
=item $>
X<< $> >> X<$EUID> X<$EFFECTIVE_USER_ID>
 
The effective uid of this process.  For example:
 
    $< = $>;            # set real to effective uid
    ($<,$>) = ($>,$<);  # swap real and effective uids
 
You can change both the effective uid and the real uid at the same
time by using C<POSIX::setuid()>.  Changes to C<< $> >> require a check
to C<$!> to detect any possible errors after an attempted change.
 
C<< $< >> and C<< $> >> can be swapped only on machines
supporting C<setreuid()>.
 
Mnemonic: it's the uid you went I<to>, if you're running setuid.
 
=item $SUBSCRIPT_SEPARATOR
 
=item $SUBSEP
 
=item $;
X<$;> X<$SUBSEP> X<SUBSCRIPT_SEPARATOR>
 
The subscript separator for multidimensional array emulation.  If you
refer to a hash element as
 
    $foo{$x,$y,$z}
 
it really means
 
    $foo{join($;, $x, $y, $z)}
 
But don't put
 
    @foo{$x,$y,$z}     # a slice--note the @
 
which means
 
    ($foo{$x},$foo{$y},$foo{$z})
 
Default is "\034", the same as SUBSEP in B<awk>.  If your keys contain
binary data there might not be any safe value for C<$;>.
 
Consider using "real" multidimensional arrays as described
in L<perllol>.
 
Mnemonic: comma (the syntactic subscript separator) is a semi-semicolon.
 
=item $a
 
=item $b
X<$a> X<$b>
 
Special package variables when using C<sort()>, see L<perlfunc/sort>.
Because of this specialness C<$a> and C<$b> don't need to be declared
(using C<use vars>, or C<our()>) even when using the C<strict 'vars'>
pragma.  Don't lexicalize them with C<my $a> or C<my $b> if you want to
be able to use them in the C<sort()> comparison block or function.
 
=item %ENV
X<%ENV>
 
The hash C<%ENV> contains your current environment.  Setting a
value in C<ENV> changes the environment for any child processes
you subsequently C<fork()> off.
 
As of v5.18.0, both keys and values stored in C<%ENV> are stringified.
 
    my $foo = 1;
    $ENV{'bar'} = \$foo;
    if( ref $ENV{'bar'} ) {
        say "Pre 5.18.0 Behaviour";
    } else {
        say "Post 5.18.0 Behaviour";
    }
 
Previously, only child processes received stringified values:
 
    my $foo = 1;
    $ENV{'bar'} = \$foo;
 
    # Always printed 'non ref'
    system($^X, '-e',
           q/print ( ref $ENV{'bar'}  ? 'ref' : 'non ref' ) /);
 
This happens because you can't really share arbitrary data structures with
foreign processes.
 
=item $OLD_PERL_VERSION
 
=item $]
X<$]> X<$OLD_PERL_VERSION>
 
The revision, version, and subversion of the Perl interpreter, represented
as a decimal of the form 5.XXXYYY, where XXX is the version / 1e3 and YYY
is the subversion / 1e6.  For example, Perl v5.10.1 would be "5.010001".
 
This variable can be used to determine whether the Perl interpreter
executing a script is in the right range of versions:
 
    warn "No PerlIO!\n" if "$]" < 5.008;
 
When comparing C<$]>, numeric comparison operators should be used, but the
variable should be stringified first to avoid issues where its original
numeric value is inaccurate.
 
See also the documentation of L<C<use VERSION>|perlfunc/use VERSION> and
C<require VERSION> for a convenient way to fail if the running Perl
interpreter is too old.
 
See L</$^V> for a representation of the Perl version as a L<version>
object, which allows more flexible string comparisons.
 
The main advantage of C<$]> over C<$^V> is that it works the same on any
version of Perl.  The disadvantages are that it can't easily be compared
to versions in other formats (e.g. literal v-strings, "v1.2.3" or
version objects) and numeric comparisons are subject to the binary
floating point representation; it's good for numeric literal version
checks and bad for comparing to a variable that hasn't been
sanity-checked.
 
The C<$OLD_PERL_VERSION> form was added in Perl v5.20.0 for historical
reasons but its use is discouraged. (If your reason to use C<$]> is to
run code on old perls then referring to it as C<$OLD_PERL_VERSION> would
be self-defeating.)
 
Mnemonic: Is this version of perl in the right bracket?
 
=item $SYSTEM_FD_MAX
 
=item $^F
X<$^F> X<$SYSTEM_FD_MAX>
 
The maximum system file descriptor, ordinarily 2.  System file
descriptors are passed to C<exec()>ed processes, while higher file
descriptors are not.  Also, during an
C<open()>, system file descriptors are
preserved even if the C<open()> fails (ordinary file descriptors are
closed before the C<open()> is attempted).  The close-on-exec
status of a file descriptor will be decided according to the value of
C<$^F> when the corresponding file, pipe, or socket was opened, not the
time of the C<exec()>.
 
=item @F
X<@F>
 
The array C<@F> contains the fields of each line read in when autosplit
mode is turned on.  See L<perlrun|perlrun/-a> for the B<-a> switch.  This
array is package-specific, and must be declared or given a full package
name if not in package main when running under C<strict 'vars'>.
 
=item @INC
X<@INC>
 
The array C<@INC> contains the list of places that the C<do EXPR>,
C<require>, or C<use> constructs look for their library files.  It
initially consists of the arguments to any B<-I> command-line
switches, followed by the default Perl library, probably
F</usr/local/lib/perl>.
Prior to Perl 5.26, C<.> -which represents the current directory, was included
in C<@INC>; it has been removed. This change in behavior is documented
in L<C<PERL_USE_UNSAFE_INC>|perlrun/PERL_USE_UNSAFE_INC> and it is
not recommended that C<.> be re-added to C<@INC>.
If you need to modify C<@INC> at runtime, you should use the C<use lib> pragma
to get the machine-dependent library properly loaded as well:
 
    use lib '/mypath/libdir/';
    use SomeMod;
 
You can also insert hooks into the file inclusion system by putting Perl
code directly into C<@INC>.  Those hooks may be subroutine references,
array references or blessed objects.  See L<perlfunc/require> for details.
 
=item %INC
X<%INC>
 
The hash C<%INC> contains entries for each filename included via the
C<do>, C<require>, or C<use> operators.  The key is the filename
you specified (with module names converted to pathnames), and the
value is the location of the file found.  The C<require>
operator uses this hash to determine whether a particular file has
already been included.
 
If the file was loaded via a hook (e.g. a subroutine reference, see
L<perlfunc/require> for a description of these hooks), this hook is
by default inserted into C<%INC> in place of a filename.  Note, however,
that the hook may have set the C<%INC> entry by itself to provide some more
specific info.
 
=item $INC
X<$INC>
 
As of 5.37.7 when an C<@INC> hook is executed the index of the C<@INC>
array that holds the hook will be localized into the C<$INC> variable.
When the hook returns the integer successor of its value will be used to
determine the next index in C<@INC> that will be checked, thus if it is
set to -1 (or C<undef>) the traversal over the C<@INC> array will be
restarted from its beginning.
 
Normally traversal through the C<@INC> array is from beginning to end
(C<0 .. $#INC>), and if the C<@INC> array is modified by the hook the
iterator may be left in a state where newly added entries are skipped.
Changing this value allows an C<@INC> hook to rewrite the C<@INC> array
and tell Perl where to continue afterwards. See L<perlfunc/require> for
details on C<@INC> hooks.
 
=item $INPLACE_EDIT
 
=item $^I
X<$^I> X<$INPLACE_EDIT>
 
The current value of the inplace-edit extension.  Use C<undef> to disable
inplace editing.
 
Mnemonic: value of B<-i> switch.
 
=item @ISA
X<@ISA>
 
Each package contains a special array called C<@ISA> which contains a list
of that class's parent classes, if any. This array is simply a list of
scalars, each of which is a string that corresponds to a package name. The
array is examined when Perl does method resolution, which is covered in
L<perlobj>.
 
To load packages while adding them to C<@ISA>, see the L<parent> pragma. The
discouraged L<base> pragma does this as well, but should not be used except
when compatibility with the discouraged L<fields> pragma is required.
 
=item $^M
X<$^M>
 
By default, running out of memory is an untrappable, fatal error.
However, if suitably built, Perl can use the contents of C<$^M>
as an emergency memory pool after C<die()>ing.  Suppose that your Perl
were compiled with C<-DPERL_EMERGENCY_SBRK> and used Perl's malloc.
Then
 
    $^M = 'a' x (1 << 16);
 
would allocate a 64K buffer for use in an emergency.  See the
L<INSTALL> file in the Perl distribution for information on how to
add custom C compilation flags when compiling perl.  To discourage casual
use of this advanced feature, there is no L<English|English> long name for
this variable.
 
This variable was added in Perl 5.004.
 
=item ${^MAX_NESTED_EVAL_BEGIN_BLOCKS}
 
This variable determines the maximum number C<eval EXPR>/C<BEGIN> or
C<require>/C<BEGIN> block nesting that is allowed. This means it also
controls the maximum nesting of C<use> statements as well.
 
The default of 1000 should be sufficiently large for normal working
purposes, and if you must raise it then you should be conservative
with your choice or you may encounter segfaults from exhaustion of
the C stack. It seems unlikely that real code has a use depth above
1000, but we have left this configurable just in case.
 
When set to C<0> then C<BEGIN> blocks inside of C<eval EXPR> or
C<require EXPR> are forbidden entirely and will trigger an exception
which will terminate the compilation and in the case of C<require>
will throw an exception, or in the case of C<eval> return the error in
C<$@> as usual.
 
Consider the code
 
 perl -le'sub f { eval "BEGIN { f() }"; } f()'
 
each invocation of C<f()> will consume considerable C stack, and this
variable is used to cause code like this to die instead of exhausting
the C stack and triggering a segfault. Needless to say code like this is
unusual, it is unlikely you will actually need to raise the setting.
However it may be useful to set it to 0 for a limited time period to
prevent BEGIN{} blocks from being executed during an C<eval EXPR>.
 
Note that setting this to 1 would NOT affect code like this:
 
    BEGIN { $n += 1; BEGIN { $n += 2; BEGIN { $n += 4 } } }
 
The reason is that BEGIN blocks are executed immediately after they are
completed, thus the innermost will execute before the ones which contain
it have even finished compiling, and the depth will not go above 1. In
fact the above code is equivalent to
 
    BEGIN { $n+=4 }
    BEGIN { $n+=2 }
    BEGIN { $n+=1 }
 
which makes it obvious why a ${^MAX_EVAL_BEGIN_DEPTH} of 1 would not
block this code.
 
Only C<BEGIN>'s executed inside of an C<eval> or C<require> (possibly via
C<use>) are affected.
 
=item $OSNAME
 
=item $^O
X<$^O> X<$OSNAME>
 
The name of the operating system under which this copy of Perl was
built, as determined during the configuration process.  For examples
see L<perlport/PLATFORMS>.
 
The value is identical to C<$Config{'osname'}>.  See also L<Config>
and the B<-V> command-line switch documented in L<perlrun|perlrun/-V>.
 
In Windows platforms, C<$^O> is not very helpful: since it is always
C<MSWin32>, it doesn't tell the difference between
95/98/ME/NT/2000/XP/CE/.NET.  Use C<Win32::GetOSName()> or
Win32::GetOSVersion() (see L<Win32> and L<perlport>) to distinguish
between the variants.
 
This variable was added in Perl 5.003.
 
=item %SIG
X<%SIG>
 
The hash C<%SIG> contains signal handlers for signals.  For example:
 
    sub handler {   # 1st argument is signal name
        my($sig) = @_;
        print "Caught a SIG$sig--shutting down\n";
        close(LOG);
        exit(0);
    }
 
    $SIG{'INT'}  = \&handler;
    $SIG{'QUIT'} = \&handler;
    ...
    $SIG{'INT'}  = 'DEFAULT';   # restore default action
    $SIG{'QUIT'} = 'IGNORE';    # ignore SIGQUIT
 
Using a value of C<'IGNORE'> usually has the effect of ignoring the
signal, except for the C<CHLD> signal.  See L<perlipc> for more about
this special case.  Using an empty string or C<undef> as the value has
the same effect as C<'DEFAULT'>.
 
Here are some other examples:
 
    $SIG{"PIPE"} = "Plumber";   # assumes main::Plumber (not
                                # recommended)
    $SIG{"PIPE"} = \&Plumber;   # just fine; assume current
                                # Plumber
    $SIG{"PIPE"} = *Plumber;    # somewhat esoteric
    $SIG{"PIPE"} = Plumber();   # oops, what did Plumber()
                                # return??
 
Be sure not to use a bareword as the name of a signal handler,
lest you inadvertently call it.
 
Using a string that doesn't correspond to any existing function or a
glob that doesn't contain a code slot is equivalent to C<'IGNORE'>,
but a warning is emitted when the handler is being called (the warning
is not emitted for the internal hooks described below).
 
If your system has the C<sigaction()> function then signal handlers
are installed using it.  This means you get reliable signal handling.
 
The default delivery policy of signals changed in Perl v5.8.0 from
immediate (also known as "unsafe") to deferred, also known as "safe
signals".  See L<perlipc> for more information.
 
Certain internal hooks can be also set using the C<%SIG> hash.  The
routine indicated by C<$SIG{__WARN__}> is called when a warning
message is about to be printed.  The warning message is passed as the
first argument.  The presence of a C<__WARN__> hook causes the
ordinary printing of warnings to C<STDERR> to be suppressed.  You can
use this to save warnings in a variable, or turn warnings into fatal
errors, like this:
 
    local $SIG{__WARN__} = sub { die $_[0] };
    eval $proggie;
 
As the C<'IGNORE'> hook is not supported by C<__WARN__>, its effect is
the same as using C<'DEFAULT'>.  You can disable warnings using the
empty subroutine:
 
    local $SIG{__WARN__} = sub {};
 
The routine indicated by C<$SIG{__DIE__}> is called when a fatal
exception is about to be thrown.  The error message is passed as the
first argument.  When a C<__DIE__> hook routine returns, the exception
processing continues as it would have in the absence of the hook,
unless the hook routine itself exits via a C<goto &sub>, a loop exit,
or a C<die()>.  The C<__DIE__> handler is explicitly disabled during
the call, so that you can die from a C<__DIE__> handler.  Similarly
for C<__WARN__>.
 
The C<$SIG{__DIE__}> hook is called even inside an C<eval()>. It was
never intended to happen this way, but an implementation glitch made
this possible. This used to be deprecated, as it allowed strange action
at a distance like rewriting a pending exception in C<$@>. Plans to
rectify this have been scrapped, as users found that rewriting a
pending exception is actually a useful feature, and not a bug.
 
The C<$SIG{__DIE__}> doesn't support C<'IGNORE'>; it has the same
effect as C<'DEFAULT'>.
 
C<__DIE__>/C<__WARN__> handlers are very special in one respect: they
may be called to report (probable) errors found by the parser.  In such
a case the parser may be in inconsistent state, so any attempt to
evaluate Perl code from such a handler will probably result in a
segfault.  This means that warnings or errors that result from parsing
Perl should be used with extreme caution, like this:
 
    require Carp if defined $^S;
    Carp::confess("Something wrong") if defined &Carp::confess;
    die "Something wrong, but could not load Carp to give "
      . "backtrace...\n\t"
      . "To see backtrace try starting Perl with -MCarp switch";
 
Here the first line will load C<Carp> I<unless> it is the parser who
called the handler.  The second line will print backtrace and die if
C<Carp> was available.  The third line will be executed only if C<Carp> was
not available.
 
Having to even think about the C<$^S> variable in your exception
handlers is simply wrong.  C<$SIG{__DIE__}> as currently implemented
invites grievous and difficult to track down errors.  Avoid it
and use an C<END{}> or CORE::GLOBAL::die override instead.
 
See L<perlfunc/die>, L<perlfunc/warn>, L<perlfunc/eval>, and
L<warnings> for additional information.
 
=item %{^HOOK}
X<%{^HOOK}>
 
This hash contains coderefs which are called when various perl keywords
which are hard or impossible to wrap are called. The keys of this hash
are named after the keyword that is being hooked, followed by two
underbars and then a phase term; either "before" or "after".
 
Perl will throw an error if you attempt modify a key which is not
documented to exist, or if you attempt to store anything other than a
code reference or undef in the hash.  If you wish to use an object to
implement a hook you can use currying to embed the object into an
anonymous code reference.
 
Currently there is only one keyword which can be hooked, C<require>, but
it is expected that in future releases there will be additional keywords
with hook support.
 
=over 4
 
=item require__before
 
The routine indicated by C<${^HOOK}{require__before}> is called by
C<require> B<before> it checks C<%INC>, looks up C<@INC>, calls INC
hooks, or compiles any code.  It is called with a single argument, the
filename for the item being required (package names are converted to
paths).  It may alter this filename to change what file is loaded.  If
the hook dies during execution then it will block the require from executing.
 
In order to make it easy to perform an action with shared state both
before and after the require keyword was executed the C<require__before>
hook may return a "post-action" coderef which will in turn be executed when
the C<require> completes.  This coderef will be executed regardless as to
whether the require completed succesfully or threw an exception.  It will
be called with the filename that was required.  You can check %INC to
determine if the require was successful.  Any other return from the
C<require__before> hook will be silently ignored.
 
C<require__before> hooks are called in FIFO order, and if the hook
returns a code reference those code references will be called in FILO
order.  In other words if A requires B requires C, then
C<require__before> will be called first for A, then B and then C, and
the post-action code reference will executed first for C, then B and
then finally A.
 
Well behaved code should ensure that when setting up a
C<require__before> hook that any prior installed hook will be called,
and that their return value, if a code reference, will be called as
well.  See L<perlfunc/require> for an example implementation.
 
=item require__after
 
The routine indicated by C<${^HOOK}{require__after}> is called by
C<require> B<after> the require completes.  It is called with a single
argument, the filename for the item being required (package names are
converted to paths).  It is executed when the C<require> completes,
either via exception or via completion of the require statement, and you
can check C<%INC> to determine if the require was successful.
 
The C<require__after> hook is called for each required file in FILO
order. In other words if A requires B requires C, then C<require__after>
will be called first for C, then B and then A.
 
=back
 
=item $BASETIME
 
=item $^T
X<$^T> X<$BASETIME>
 
The time at which the program began running, in seconds since the
epoch (beginning of 1970).  The values returned by the B<-M>, B<-A>,
and B<-C> filetests are based on this value.
 
=item $PERL_VERSION
 
=item $^V
X<$^V> X<$PERL_VERSION>
 
=for comment
These are documented in the generated file lib/Config.pod.  This looks
like as good a place as any to give notice that they are documented.
 
The revision, version, and subversion of the Perl interpreter,
represented as a L<version> object.
 
This variable first appeared in perl v5.6.0; earlier versions of perl
will see an undefined value.  Before perl v5.10.0 C<$^V> was represented
as a v-string rather than a L<version> object.
 
C<$^V> can be used to determine whether the Perl interpreter executing
a script is in the right range of versions.  For example:
 
    warn "Hashes not randomized!\n" if !$^V or $^V lt v5.8.1
 
While version objects overload stringification, to portably convert
C<$^V> into its string representation, use C<sprintf()>'s C<"%vd">
conversion, which works for both v-strings or version objects:
 
    printf "version is v%vd\n", $^V;  # Perl's version
 
See the documentation of C<use VERSION> and C<require VERSION>
for a convenient way to fail if the running Perl interpreter is too old.
 
See also C<L</$]>> for a decimal representation of the Perl version.
 
The main advantage of C<$^V> over C<$]> is that, for Perl v5.10.0 or
later, it overloads operators, allowing easy comparison against other
version representations (e.g. decimal, literal v-string, "v1.2.3", or
objects).  The disadvantage is that prior to v5.10.0, it was only a
literal v-string, which can't be easily printed or compared, whereas
the behavior of C<$]> is unchanged on all versions of Perl.
 
Mnemonic: use ^V for a version object.
 
=item $EXECUTABLE_NAME
 
=item $^X
X<$^X> X<$EXECUTABLE_NAME>
 
The name used to execute the current copy of Perl, from C's
C<argv[0]> or (where supported) F</proc/self/exe>.
 
Depending on the host operating system, the value of C<$^X> may be
a relative or absolute pathname of the perl program file, or may
be the string used to invoke perl but not the pathname of the
perl program file.  Also, most operating systems permit invoking
programs that are not in the PATH environment variable, so there
is no guarantee that the value of C<$^X> is in PATH.  For VMS, the
value may or may not include a version number.
 
You usually can use the value of C<$^X> to re-invoke an independent
copy of the same perl that is currently running, e.g.,
 
    @first_run = `$^X -le "print int rand 100 for 1..100"`;
 
But recall that not all operating systems support forking or
capturing of the output of commands, so this complex statement
may not be portable.
 
It is not safe to use the value of C<$^X> as a path name of a file,
as some operating systems that have a mandatory suffix on
executable files do not require use of the suffix when invoking
a command.  To convert the value of C<$^X> to a path name, use the
following statements:
 
    # Build up a set of file names (not command names).
    use Config;
    my $this_perl = $^X;
    if ($^O ne 'VMS') {
        $this_perl .= $Config{_exe}
        unless $this_perl =~ m/$Config{_exe}$/i;
    }
 
Because many operating systems permit anyone with read access to
the Perl program file to make a copy of it, patch the copy, and
then execute the copy, the security-conscious Perl programmer
should take care to invoke the installed copy of perl, not the
copy referenced by C<$^X>.  The following statements accomplish
this goal, and produce a pathname that can be invoked as a
command or referenced as a file.
 
    use Config;
    my $secure_perl_path = $Config{perlpath};
    if ($^O ne 'VMS') {
        $secure_perl_path .= $Config{_exe}
        unless $secure_perl_path =~ m/$Config{_exe}$/i;
    }
 
=back
 
=head2 Variables related to regular expressions
 
Most of the special variables related to regular expressions are side
effects. Perl sets these variables when it has completed a match
successfully, so you should check the match result before using them.
For instance:
 
    if( /P(A)TT(ER)N/ ) {
        print "I found $1 and $2\n";
    }
 
These variables are read-only and behave similarly to a dynamically
scoped variable, with only a few exceptions which are explicitly
documented as behaving otherwise.  See the following section for more
details.
 
=head3 Scoping Rules of Regex Variables
 
Regular expression variables allow the programmer to access the state of
the most recent I<successful> regex match in the current dynamic scope.
 
The variables themselves are global and unscoped, but the data they
access is scoped similarly to dynamically scoped variables, in that
every successful match behaves as though it localizes a global state
object to the current block or file scope.
(See L<perlsyn/"Compound Statements"> for more details on dynamic
scoping and the C<local> keyword.)
 
A I<successful match> includes any successful match performed by the
search and replace operator C<s///> as well as those performed by the
C<m//> operator.
 
Consider the following code:
 
    my @state;
    sub matchit {
        push @state, $1;            # pushes "baz"
        my $str = shift;
        $str =~ /(zat)/;            # matches "zat"
        push @state, $1;            # pushes "zat"
    }
 
    {
        $str = "foo bar baz blorp zat";
        $str =~ /(foo)/;            # matches "foo"
        push @state, $1;            # pushes "foo"
        {
            $str =~ /(pizza)/;      # does NOT match
            push @state, $1;        # pushes "foo"
            $str =~ /(bar)/;        # matches "bar"
            push @state, $1;        # pushes "bar"
            $str =~ /(baz)/;        # matches "baz"
            matchit($str);          # see above
            push @state, $1;        # pushes "baz"
        }
        $str =~ s/noodles/rice/;    # does NOT match
        push @state, $1;            # pushes "foo"
        $str =~ s/(blorp)/zwoop/;   # matches "blorp"
        push @state, $1;            # pushes "blorp"
    }
    # the following prints "foo, foo, bar, baz, zat, baz, foo, blorp"
    print join ",", @state;
 
Notice that each successful match in the exact same scope overrides the
match context of the previous successful match, but that unsuccessful
matches do not. Also note that in an inner nested scope the previous
state from an outer dynamic scope persists until it has been overriden
by another successful match, but that when the inner nested scope exits
whatever match context was in effect before the inner successful match
is restored when the scope concludes.
 
It is a known issue that C<goto LABEL> may interact poorly with the
dynamically scoped match context. This may not be fixable, and is
considered to be one of many good reasons to avoid C<goto LABEL>.
 
=head3 Performance issues
 
Traditionally in Perl, any use of any of the three variables  C<$`>, C<$&>
or C<$'> (or their C<use English> equivalents) anywhere in the code, caused
all subsequent successful pattern matches to make a copy of the matched
string, in case the code might subsequently access one of those variables.
This imposed a considerable performance penalty across the whole program,
so generally the use of these variables has been discouraged.
 
In Perl 5.6.0 the C<@-> and C<@+> dynamic arrays were introduced that
supply the indices of successful matches. So you could for example do
this:
 
    $str =~ /pattern/;
 
    print $`, $&, $'; # bad: performance hit
 
    print             # good: no performance hit
    substr($str, 0,     $-[0]),
    substr($str, $-[0], $+[0]-$-[0]),
    substr($str, $+[0]);
 
In Perl 5.10.0 the C</p> match operator flag and the C<${^PREMATCH}>,
C<${^MATCH}>, and C<${^POSTMATCH}> variables were introduced, that allowed
you to suffer the penalties only on patterns marked with C</p>.
 
In Perl 5.18.0 onwards, perl started noting the presence of each of the
three variables separately, and only copied that part of the string
required; so in
 
    $`; $&; "abcdefgh" =~ /d/
 
perl would only copy the "abcd" part of the string. That could make a big
difference in something like
 
    $str = 'x' x 1_000_000;
    $&; # whoops
    $str =~ /x/g # one char copied a million times, not a million chars
 
In Perl 5.20.0 a new copy-on-write system was enabled by default, which
finally fixes most of the performance issues with these three variables, and
makes them safe to use anywhere.
 
The C<Devel::NYTProf> and C<Devel::FindAmpersand> modules can help you
find uses of these problematic match variables in your code.
 
=over 8
 
=item $<I<digits>> ($1, $2, ...)
X<$1> X<$2> X<$3> X<$I<digits>>
 
Contains the subpattern from the corresponding set of capturing
parentheses from the last successful pattern match in the current
dynamic scope. (See L</Scoping Rules of Regex Variables>.)
 
Note there is a distinction between a capture buffer which matches
the empty string a capture buffer which is optional. Eg, C<(x?)> and
C<(x)?> The latter may be undef, the former not.
 
These variables are read-only.
 
Mnemonic: like \digits.
 
=item @{^CAPTURE}
X<@{^CAPTURE}> X<@^CAPTURE>
 
An array which exposes the contents of the capture buffers, if any, of
the last successful pattern match, not counting patterns matched
in nested blocks that have been exited already.
 
Note that the 0 index of @{^CAPTURE} is equivalent to $1, the 1 index
is equivalent to $2, etc.
 
    if ("foal"=~/(.)(.)(.)(.)/) {
        print join "-", @{^CAPTURE};
    }
 
should output "f-o-a-l".
 
See also L<<< /$<I<digits>> ($1, $2, ...) >>>, L</%{^CAPTURE}> and
L</%{^CAPTURE_ALL}>.
 
Note that unlike most other regex magic variables there is no single
letter equivalent to C<@{^CAPTURE}>. Also be aware that when
interpolating subscripts of this array you B<must> use the demarcated
variable form, for instance
 
    print "${^CAPTURE[0]}"
 
see L<perldata/"Demarcated variable names using braces"> for more
information on this form and its uses.
 
This variable was added in 5.25.7
 
=item $MATCH
 
=item $&
X<$&> X<$MATCH>
 
The string matched by the last successful pattern match.
(See L</Scoping Rules of Regex Variables>.)
 
See L</Performance issues> above for the serious performance implications
of using this variable (even once) in your code.
 
This variable is read-only, and its value is dynamically scoped.
 
Mnemonic: like C<&> in some editors.
 
=item ${^MATCH}
X<${^MATCH}>
 
It is only guaranteed to return a defined value when the pattern was
compiled or executed with the C</p> modifier.
 
This is similar to C<$&> (C<$MATCH>) except that to use it you must
use the C</p> modifier when executing the pattern, and it does not incur
and performance penalty associated with that variable.
 
See L</Performance issues> above.
 
This variable was added in Perl v5.10.0.
 
This variable is read-only, and its value is dynamically scoped.
 
=item $PREMATCH
 
=item $`
X<$`> X<$PREMATCH>
 
The string preceding whatever was matched by the last successful
pattern match. (See L</Scoping Rules of Regex Variables>).
 
See L</Performance issues> above for the serious performance implications
of using this variable (even once) in your code.
 
This variable is read-only, and its value is dynamically scoped.
 
Mnemonic: C<`> often precedes a quoted string.
 
=item ${^PREMATCH}
X<${^PREMATCH}>
 
It is only guaranteed to return a defined value when the pattern was
executed with the C</p> modifier.
 
This is similar to C<$`> ($PREMATCH) except that to use it you must
use the C</p> modifier when executing the pattern, and it does not incur
and performance penalty associated with that variable.
 
See L</Performance issues> above.
 
 
This variable was added in Perl v5.10.0.
 
This variable is read-only, and its value is dynamically scoped.
 
=item $POSTMATCH
 
=item $'
X<$'> X<$POSTMATCH> X<@->
 
The string following whatever was matched by the last successful
pattern match. (See L</Scoping Rules of Regex Variables>). Example:
 
    local $_ = 'abcdefghi';
    /def/;
    print "$`:$&:$'\n";       # prints abc:def:ghi
 
See L</Performance issues> above for the serious performance implications
of using this variable (even once) in your code.
 
This variable is read-only, and its value is dynamically scoped.
 
Mnemonic: C<'> often follows a quoted string.
 
=item ${^POSTMATCH}
X<${^POSTMATCH}>
 
It is only guaranteed to return a defined value when the pattern was
compiled or executed with the C</p> modifier.
 
This is similar to C<$'> (C<$POSTMATCH>) except that to use it you must
use the C</p> modifier when executing the pattern, and it does not incur
and performance penalty associated with that variable.
 
See L</Performance issues> above.
 
This variable was added in Perl v5.10.0.
 
This variable is read-only, and its value is dynamically scoped.
 
=item $LAST_PAREN_MATCH
 
=item $+
X<$+> X<$LAST_PAREN_MATCH>
 
The text matched by the highest used capture group of the last
successful search pattern. (See L</Scoping Rules of Regex Variables>).
It is logically equivalent to the highest
numbered capture variable (C<$1>, C<$2>, ...) which has a defined value.
 
This is useful if you don't know which one of a set of alternative patterns
matched.  For example:
 
    /Version: (.*)|Revision: (.*)/ && ($rev = $+);
 
This variable is read-only, and its value is dynamically scoped.
 
Mnemonic: be positive and forward looking.
 
=item $LAST_SUBMATCH_RESULT
 
=item $^N
X<$^N> X<$LAST_SUBMATCH_RESULT>
 
The text matched by the used group most-recently closed (i.e. the group
with the rightmost closing parenthesis) of the last successful match.
(See L</Scoping Rules of Regex Variables>).
 
 
This is subtly different from C<$+>. For example in
 
    "ab" =~ /^((.)(.))$/
 
we have
 
    $1,$^N   have the value "ab"
    $2       has  the value "a"
    $3,$+    have the value "b"
 
This is primarily used inside C<(?{...})> blocks for examining text
recently matched.  For example, to effectively capture text to a variable
(in addition to C<$1>, C<$2>, etc.), replace C<(...)> with
 
    (?:(...)(?{ $var = $^N }))
 
By setting and then using C<$var> in this way relieves you from having to
worry about exactly which numbered set of parentheses they are.
 
This variable is read-only, and its value is dynamically scoped.
 
This variable was added in Perl v5.8.0.
 
Mnemonic: the (possibly) Nested parenthesis that most recently closed.
 
=item @LAST_MATCH_END
 
=item @+
X<@+> X<@LAST_MATCH_END>
 
This array holds the offsets of the ends of the last successful
match and any matching capture buffers that the pattern contains.
(See L</Scoping Rules of Regex Variables>)
 
The number of elements it contains will be one more than the number
of capture buffers in the pattern, regardless of which capture buffers
actually matched. You can use this to determine how many capture
buffers there are in the pattern. (As opposed to C<@-> which may
have fewer elements.)
 
C<$+[0]> is the offset into the string of the end of the entire match.
This is the same value as what the C<pos> function returns when called
on the variable that was matched against. The I<n>th element of this
array holds the offset of the I<n>th submatch, so C<$+[1]> is the offset
past where C<$1> ends, C<$+[2]> the offset past where C<$2> ends, and so
on. You can use C<$#+> to determine how many subgroups were in the last
successful match. See the examples given for the C<@-> variable.
 
This variable is read-only, and its value is dynamically scoped.
 
This variable was added in Perl v5.6.0.
 
=item %{^CAPTURE}
 
=item %LAST_PAREN_MATCH
 
=item %+
X<%+> X<%LAST_PAREN_MATCH> X<%{^CAPTURE}>
 
Similar to C<@+>, the C<%+> hash allows access to the named capture
buffers, should they exist, in the last successful match in the
currently active dynamic scope. (See L</Scoping Rules of Regex Variables>).
 
For example, C<$+{foo}> is equivalent to C<$1> after the following match:
 
    'foo' =~ /(?<foo>foo)/;
 
The keys of the C<%+> hash list only the names of buffers that have
captured (and that are thus associated to defined values).
 
If multiple distinct capture groups have the same name, then
C<$+{NAME}> will refer to the leftmost defined group in the match.
 
The underlying behaviour of C<%+> is provided by the
L<Tie::Hash::NamedCapture> module.
 
B<Note:> C<%-> and C<%+> are tied views into a common internal hash
associated with the last successful regular expression.  Therefore mixing
iterative access to them via C<each> may have unpredictable results.
Likewise, if the last successful match changes, then the results may be
surprising.
 
This variable was added in Perl v5.10.0. The C<%{^CAPTURE}> alias was
added in 5.25.7.
 
This variable is read-only, and its value is dynamically scoped.
 
=item @LAST_MATCH_START
 
=item @-
X<@-> X<@LAST_MATCH_START>
 
This array holds the offsets of the beginnings of the last successful
match and any capture buffers it contains.
(See L</Scoping Rules of Regex Variables>).
 
The number of elements it contains will be one more than the number of
the highest capture buffers (also called a subgroup) that actually
matched something. (As opposed to C<@+> which may have fewer elements.)
 
C<$-[0]> is the offset of the start of the last successful match.
C<$-[I<n>]> is the offset of the start of the substring matched by
I<n>-th subpattern, or undef if the subpattern did not match.
 
Thus, after a match against C<$_>, C<$&> coincides with
C<substr $_, $-[0], $+[0] - $-[0]>.  Similarly, C<$I<n>> coincides
with C<substr $_, $-[n], $+[n] - $-[n]> if C<$-[n]> is defined, and
C<$+> coincides with C<substr $_, $-[$#-], $+[$#-] - $-[$#-]>.
One can use C<$#-> to find the last matched subgroup in the last
successful match.  Contrast with C<$#+>, the number of subgroups
in the regular expression.
 
C<$-[0]> is the offset into the string of the beginning of the
entire match.  The I<n>th element of this array holds the offset
of the I<n>th submatch, so C<$-[1]> is the offset where C<$1>
begins, C<$-[2]> the offset where C<$2> begins, and so on.
 
After a match against some variable C<$var>:
 
=over 5
 
=item C<$`> is the same as C<substr($var, 0, $-[0])>
 
=item C<$&> is the same as C<substr($var, $-[0], $+[0] - $-[0])>
 
=item C<$'> is the same as C<substr($var, $+[0])>
 
=item C<$1> is the same as C<substr($var, $-[1], $+[1] - $-[1])>
 
=item C<$2> is the same as C<substr($var, $-[2], $+[2] - $-[2])>
 
=item C<$3> is the same as C<substr($var, $-[3], $+[3] - $-[3])>
 
=back
 
This variable is read-only, and its value is dynamically scoped.
 
This variable was added in Perl v5.6.0.
 
=item %{^CAPTURE_ALL}
X<%{^CAPTURE_ALL}>
 
=item %-
X<%->
 
Similar to C<%+>, this variable allows access to the named capture
groups in the last successful match in the currently active dynamic
scope. (See L</Scoping Rules of Regex Variables>). To each capture group
name found in the regular expression, it associates a reference to an
array containing the list of values captured by all buffers with that
name (should there be several of them), in the order where they appear.
 
Here's an example:
 
    if ('1234' =~ /(?<A>1)(?<B>2)(?<A>3)(?<B>4)/) {
        foreach my $bufname (sort keys %-) {
            my $ary = $-{$bufname};
            foreach my $idx (0..$#$ary) {
                print "\$-{$bufname}[$idx] : ",
                      (defined($ary->[$idx])
                          ? "'$ary->[$idx]'"
                          : "undef"),
                      "\n";
            }
        }
    }
 
would print out:
 
    $-{A}[0] : '1'
    $-{A}[1] : '3'
    $-{B}[0] : '2'
    $-{B}[1] : '4'
 
The keys of the C<%-> hash correspond to all buffer names found in
the regular expression.
 
The behaviour of C<%-> is implemented via the
L<Tie::Hash::NamedCapture> module.
 
B<Note:> C<%-> and C<%+> are tied views into a common internal hash
associated with the last successful regular expression.  Therefore mixing
iterative access to them via C<each> may have unpredictable results.
Likewise, if the last successful match changes, then the results may be
surprising. See L</Scoping Rules of Regex Variables>.
 
This variable was added in Perl v5.10.0. The C<%{^CAPTURE_ALL}> alias was
added in 5.25.7.
 
This variable is read-only, and its value is dynamically scoped.
 
=item ${^LAST_SUCCESSFUL_PATTERN}
 
The last successful pattern that matched in the current scope.  The empty
pattern defaults to matching to this. For instance:
 
    if (m/foo/ || m/bar/) {
        s//BLAH/;
    }
 
and
 
    if (m/foo/ || m/bar/) {
        s/${^LAST_SUCCESSFUL_PATTERN}/BLAH/;
    }
 
are equivalent.
 
You can use this to debug which pattern matched last, or to match with it again.
 
Added in Perl 5.37.10.
 
=item $LAST_REGEXP_CODE_RESULT
 
=item $^R
X<$^R> X<$LAST_REGEXP_CODE_RESULT>
 
The result of evaluation of the last successful C<(?{ code })>
regular expression assertion (see L<perlre>).
 
This variable may be written to, and its value is scoped normally,
unlike most other regex variables.
 
This variable was added in Perl 5.005.
 
=item ${^RE_COMPILE_RECURSION_LIMIT}
X<${^RE_COMPILE_RECURSION_LIMIT}>
 
The current value giving the maximum number of open but unclosed
parenthetical groups there may be at any point during a regular
expression compilation.  The default is currently 1000 nested groups.
You may adjust it depending on your needs and the amount of memory
available.
 
This variable was added in Perl v5.30.0.
 
=item ${^RE_DEBUG_FLAGS}
X<${^RE_DEBUG_FLAGS}>
 
The current value of the regex debugging flags.  Set to 0 for no debug output
even when the C<re 'debug'> module is loaded.  See L<re> for details.
 
This variable was added in Perl v5.10.0.
 
=item ${^RE_TRIE_MAXBUF}
X<${^RE_TRIE_MAXBUF}>
 
Controls how certain regex optimisations are applied and how much memory they
utilize.  This value by default is 65536 which corresponds to a 512kB
temporary cache.  Set this to a higher value to trade
memory for speed when matching large alternations.  Set
it to a lower value if you want the optimisations to
be as conservative of memory as possible but still occur, and set it to a
negative value to prevent the optimisation and conserve the most memory.
Under normal situations this variable should be of no interest to you.
 
This variable was added in Perl v5.10.0.
 
=back
 
=head2 Variables related to filehandles
 
Variables that depend on the currently selected filehandle may be set
by calling an appropriate object method on the C<IO::Handle> object,
although this is less efficient than using the regular built-in
variables.  (Summary lines below for this contain the word HANDLE.)
First you must say
 
    use IO::Handle;
 
after which you may use either
 
    method HANDLE EXPR
 
or more safely,
 
    HANDLE->method(EXPR)
 
Each method returns the old value of the C<IO::Handle> attribute.  The
methods each take an optional EXPR, which, if supplied, specifies the
new value for the C<IO::Handle> attribute in question.  If not
supplied, most methods do nothing to the current value--except for
C<autoflush()>, which will assume a 1 for you, just to be different.
 
Because loading in the C<IO::Handle> class is an expensive operation,
you should learn how to use the regular built-in variables.
 
A few of these variables are considered "read-only".  This means that
if you try to assign to this variable, either directly or indirectly
through a reference, you'll raise a run-time exception.
 
You should be very careful when modifying the default values of most
special variables described in this document.  In most cases you want
to localize these variables before changing them, since if you don't,
the change may affect other modules which rely on the default values
of the special variables that you have changed.  This is one of the
correct ways to read the whole file at once:
 
    open my $fh, "<", "foo" or die $!;
    local $/; # enable localized slurp mode
    my $content = <$fh>;
    close $fh;
 
But the following code is quite bad:
 
    open my $fh, "<", "foo" or die $!;
    undef $/; # enable slurp mode
    my $content = <$fh>;
    close $fh;
 
since some other module, may want to read data from some file in the
default "line mode", so if the code we have just presented has been
executed, the global value of C<$/> is now changed for any other code
running inside the same Perl interpreter.
 
Usually when a variable is localized you want to make sure that this
change affects the shortest scope possible.  So unless you are already
inside some short C<{}> block, you should create one yourself.  For
example:
 
    my $content = '';
    open my $fh, "<", "foo" or die $!;
    {
        local $/;
        $content = <$fh>;
    }
    close $fh;
 
Here is an example of how your own code can go broken:
 
    for ( 1..3 ){
        $\ = "\r\n";
        nasty_break();
        print "$_";
    }
 
    sub nasty_break {
        $\ = "\f";
        # do something with $_
    }
 
You probably expect this code to print the equivalent of
 
    "1\r\n2\r\n3\r\n"
 
but instead you get:
 
    "1\f2\f3\f"
 
Why? Because C<nasty_break()> modifies C<$\> without localizing it
first.  The value you set in  C<nasty_break()> is still there when you
return.  The fix is to add C<local()> so the value doesn't leak out of
C<nasty_break()>:
 
    local $\ = "\f";
 
It's easy to notice the problem in such a short example, but in more
complicated code you are looking for trouble if you don't localize
changes to the special variables.
 
=over 8
 
=item $ARGV
X<$ARGV>
 
Contains the name of the current file when reading from C<< <> >>.
 
=item @ARGV
X<@ARGV>
 
The array C<@ARGV> contains the command-line arguments intended for
the script.  C<$#ARGV> is generally the number of arguments minus
one, because C<$ARGV[0]> is the first argument, I<not> the program's
command name itself.  See L</$0> for the command name.
 
=item ARGV
X<ARGV>
 
The special filehandle that iterates over command-line filenames in
C<@ARGV>.  Usually written as the null filehandle in the angle operator
C<< <> >>.  Note that currently C<ARGV> only has its magical effect
within the C<< <> >> operator; elsewhere it is just a plain filehandle
corresponding to the last file opened by C<< <> >>.  In particular,
passing C<\*ARGV> as a parameter to a function that expects a filehandle
may not cause your function to automatically read the contents of all the
files in C<@ARGV>.
 
=item ARGVOUT
X<ARGVOUT>
 
The special filehandle that points to the currently open output file
when doing edit-in-place processing with B<-i>.  Useful when you have
to do a lot of inserting and don't want to keep modifying C<$_>.  See
L<perlrun|perlrun/-i[extension]> for the B<-i> switch.
 
=item IO::Handle->output_field_separator( EXPR )
 
=item $OUTPUT_FIELD_SEPARATOR
 
=item $OFS
 
=item $,
X<$,> X<$OFS> X<$OUTPUT_FIELD_SEPARATOR>
 
The output field separator for the print operator.  If defined, this
value is printed between each of print's arguments.  Default is C<undef>.
 
You cannot call C<output_field_separator()> on a handle, only as a
static method.  See L<IO::Handle|IO::Handle>.
 
Mnemonic: what is printed when there is a "," in your print statement.
 
=item HANDLE->input_line_number( EXPR )
 
=item $INPUT_LINE_NUMBER
 
=item $NR
 
=item $.
X<$.> X<$NR> X<$INPUT_LINE_NUMBER> X<line number>
 
Current line number for the last filehandle accessed.
 
Each filehandle in Perl counts the number of lines that have been read
from it.  (Depending on the value of C<$/>, Perl's idea of what
constitutes a line may not match yours.)  When a line is read from a
filehandle (via C<readline()> or C<< <> >>), or when C<tell()> or
C<seek()> is called on it, C<$.> becomes an alias to the line counter
for that filehandle.
 
You can adjust the counter by assigning to C<$.>, but this will not
actually move the seek pointer.  I<Localizing C<$.> will not localize
the filehandle's line count>.  Instead, it will localize perl's notion
of which filehandle C<$.> is currently aliased to.
 
C<$.> is reset when the filehandle is closed, but B<not> when an open
filehandle is reopened without an intervening C<close()>.  For more
details, see L<perlop/"IE<sol>O Operators">.  Because C<< <> >> never does
an explicit close, line numbers increase across C<ARGV> files (but see
examples in L<perlfunc/eof>).
 
You can also use C<< HANDLE->input_line_number(EXPR) >> to access the
line counter for a given filehandle without having to worry about
which handle you last accessed.
 
Mnemonic: many programs use "." to mean the current line number.
 
=item IO::Handle->input_record_separator( EXPR )
 
=item $INPUT_RECORD_SEPARATOR
 
=item $RS
 
=item $/
X<$/> X<$RS> X<$INPUT_RECORD_SEPARATOR>
 
The input record separator, newline by default.  This influences Perl's
idea of what a "line" is.  Works like B<awk>'s RS variable, including
treating empty lines as a terminator if set to the null string (an
empty line cannot contain any spaces or tabs).  You may set it to a
multi-character string to match a multi-character terminator, or to
C<undef> to read through the end of file.  Setting it to C<"\n\n">
means something slightly different than setting to C<"">, if the file
contains consecutive empty lines.  Setting to C<""> will treat two or
more consecutive empty lines as a single empty line.  Setting to
C<"\n\n"> will blindly assume that the next input character belongs to
the next paragraph, even if it's a newline.
 
    local $/;           # enable "slurp" mode
    local $_ = <FH>;    # whole file now here
    s/\n[ \t]+/ /g;
 
Remember: the value of C<$/> is a string, not a regex.  B<awk> has to
be better for something. :-)
 
Setting C<$/> to an empty string -- the so-called I<paragraph mode> -- merits
special attention.  When C<$/> is set to C<""> and the entire file is read in
with that setting, any sequence of one or more consecutive newlines at the
beginning of the file is discarded.  With the exception of the final record in
the file, each sequence of characters ending in two or more newlines is
treated as one record and is read in to end in exactly two newlines.  If the
last record in the file ends in zero or one consecutive newlines, that record
is read in with that number of newlines.  If the last record ends in two or
more consecutive newlines, it is read in with two newlines like all preceding
records.
 
Suppose we wrote the following string to a file:
 
    my $string = "\n\n\n";
    $string .= "alpha beta\ngamma delta\n\n\n";
    $string .= "epsilon zeta eta\n\n";
    $string .= "theta\n";
 
    my $file = 'simple_file.txt';
    open my $OUT, '>', $file or die;
    print $OUT $string;
    close $OUT or die;
 
Now we read that file in paragraph mode:
 
    local $/ = ""; # paragraph mode
    open my $IN, '<', $file or die;
    my @records = <$IN>;
    close $IN or die;
 
C<@records> will consist of these 3 strings:
 
    (
      "alpha beta\ngamma delta\n\n",
      "epsilon zeta eta\n\n",
      "theta\n",
    )
 
Setting C<$/> to a reference to an integer, scalar containing an
integer, or scalar that's convertible to an integer will attempt to
read records instead of lines, with the maximum record size being the
referenced integer number of characters.  So this:
 
    local $/ = \32768; # or \"32768", or \$var_containing_32768
    open my $fh, "<", $myfile or die $!;
    local $_ = <$fh>;
 
will read a record of no more than 32768 characters from $fh.  If you're
not reading from a record-oriented file (or your OS doesn't have
record-oriented files), then you'll likely get a full chunk of data
with every read.  If a record is larger than the record size you've
set, you'll get the record back in pieces.  Trying to set the record
size to zero or less is deprecated and will cause $/ to have the value
of "undef", which will cause reading in the (rest of the) whole file.
 
As of 5.19.9 setting C<$/> to any other form of reference will throw a
fatal exception. This is in preparation for supporting new ways to set
C<$/> in the future.
 
On VMS only, record reads bypass PerlIO layers and any associated
buffering, so you must not mix record and non-record reads on the
same filehandle.  Record mode mixes with line mode only when the
same buffering layer is in use for both modes.
 
You cannot call C<input_record_separator()> on a handle, only as a
static method.  See L<IO::Handle|IO::Handle>.
 
See also L<perlport/"Newlines">.  Also see L</$.>.
 
Mnemonic: / delimits line boundaries when quoting poetry.
 
=item IO::Handle->output_record_separator( EXPR )
 
=item $OUTPUT_RECORD_SEPARATOR
 
=item $ORS
 
=item $\
X<$\> X<$ORS> X<$OUTPUT_RECORD_SEPARATOR>
 
The output record separator for the print operator.  If defined, this
value is printed after the last of print's arguments.  Default is C<undef>.
 
You cannot call C<output_record_separator()> on a handle, only as a
static method.  See L<IO::Handle|IO::Handle>.
 
Mnemonic: you set C<$\> instead of adding "\n" at the end of the print.
Also, it's just like C<$/>, but it's what you get "back" from Perl.
 
=item HANDLE->autoflush( EXPR )
 
=item $OUTPUT_AUTOFLUSH
 
=item $|
X<$|> X<autoflush> X<flush> X<$OUTPUT_AUTOFLUSH>
 
If set to nonzero, forces a flush right away and after every write or
print on the currently selected output channel.  Default is 0
(regardless of whether the channel is really buffered by the system or
not; C<$|> tells you only whether you've asked Perl explicitly to
flush after each write).  STDOUT will typically be line buffered if
output is to the terminal and block buffered otherwise.  Setting this
variable is useful primarily when you are outputting to a pipe or
socket, such as when you are running a Perl program under B<rsh> and
want to see the output as it's happening.  This has no effect on input
buffering.  See L<perlfunc/getc> for that.  See L<perlfunc/select> on
how to select the output channel.  See also L<IO::Handle>.
 
Mnemonic: when you want your pipes to be piping hot.
 
=item ${^LAST_FH}
X<${^LAST_FH}>
 
This read-only variable contains a reference to the last-read filehandle.
This is set by C<< <HANDLE> >>, C<readline>, C<tell>, C<eof> and C<seek>.
This is the same handle that C<$.> and C<tell> and C<eof> without arguments
use.  It is also the handle used when Perl appends ", <STDIN> line 1" to
an error or warning message.
 
This variable was added in Perl v5.18.0.
 
=back
 
=head3 Variables related to formats
 
The special variables for formats are a subset of those for
filehandles.  See L<perlform> for more information about Perl's
formats.
 
=over 8
 
=item $ACCUMULATOR
 
=item $^A
X<$^A> X<$ACCUMULATOR>
 
The current value of the C<write()> accumulator for C<format()> lines.
A format contains C<formline()> calls that put their result into
C<$^A>.  After calling its format, C<write()> prints out the contents
of C<$^A> and empties.  So you never really see the contents of C<$^A>
unless you call C<formline()> yourself and then look at it.  See
L<perlform> and L<perlfunc/"formline PICTURE,LIST">.
 
=item IO::Handle->format_formfeed(EXPR)
 
=item $FORMAT_FORMFEED
 
=item $^L
X<$^L> X<$FORMAT_FORMFEED>
 
What formats output as a form feed.  The default is C<\f>.
 
You cannot call C<format_formfeed()> on a handle, only as a static
method.  See L<IO::Handle|IO::Handle>.
 
=item HANDLE->format_page_number(EXPR)
 
=item $FORMAT_PAGE_NUMBER
 
=item $%
X<$%> X<$FORMAT_PAGE_NUMBER>
 
The current page number of the currently selected output channel.
 
Mnemonic: C<%> is page number in B<nroff>.
 
=item HANDLE->format_lines_left(EXPR)
 
=item $FORMAT_LINES_LEFT
 
=item $-
X<$-> X<$FORMAT_LINES_LEFT>
 
The number of lines left on the page of the currently selected output
channel.
 
Mnemonic: lines_on_page - lines_printed.
 
=item IO::Handle->format_line_break_characters EXPR
 
=item $FORMAT_LINE_BREAK_CHARACTERS
 
=item $:
X<$:> X<FORMAT_LINE_BREAK_CHARACTERS>
 
The current set of characters after which a string may be broken to
fill continuation fields (starting with C<^>) in a format.  The default is
S<" \n-">, to break on a space, newline, or a hyphen.
 
You cannot call C<format_line_break_characters()> on a handle, only as
a static method.  See L<IO::Handle|IO::Handle>.
 
Mnemonic: a "colon" in poetry is a part of a line.
 
=item HANDLE->format_lines_per_page(EXPR)
 
=item $FORMAT_LINES_PER_PAGE
 
=item $=
X<$=> X<$FORMAT_LINES_PER_PAGE>
 
The current page length (printable lines) of the currently selected
output channel.  The default is 60.
 
Mnemonic: = has horizontal lines.
 
=item HANDLE->format_top_name(EXPR)
 
=item $FORMAT_TOP_NAME
 
=item $^
X<$^> X<$FORMAT_TOP_NAME>
 
The name of the current top-of-page format for the currently selected
output channel.  The default is the name of the filehandle with C<_TOP>
appended.  For example, the default format top name for the C<STDOUT>
filehandle is C<STDOUT_TOP>.
 
Mnemonic: points to top of page.
 
=item HANDLE->format_name(EXPR)
 
=item $FORMAT_NAME
 
=item $~
X<$~> X<$FORMAT_NAME>
 
The name of the current report format for the currently selected
output channel.  The default format name is the same as the filehandle
name.  For example, the default format name for the C<STDOUT>
filehandle is just C<STDOUT>.
 
Mnemonic: brother to C<$^>.
 
=back
 
=head2 Error Variables
X<error> X<exception>
 
The variables C<$@>, C<$!>, C<$^E>, and C<$?> contain information
about different types of error conditions that may appear during
execution of a Perl program.  The variables are shown ordered by
the "distance" between the subsystem which reported the error and
the Perl process.  They correspond to errors detected by the Perl
interpreter, C library, operating system, or an external program,
respectively.
 
To illustrate the differences between these variables, consider the
following Perl expression, which uses a single-quoted string.  After
execution of this statement, perl may have set all four special error
variables:
 
    eval q{
        open my $pipe, "/cdrom/install |" or die $!;
        my @res = <$pipe>;
        close $pipe or die "bad pipe: $?, $!";
    };
 
When perl executes the C<eval()> expression, it translates the
C<open()>, C<< <PIPE> >>, and C<close> calls in the C run-time library
and thence to the operating system kernel.  perl sets C<$!> to
the C library's C<errno> if one of these calls fails.
 
C<$@> is set if the string to be C<eval>-ed did not compile (this may
happen if C<open> or C<close> were imported with bad prototypes), or
if Perl code executed during evaluation C<die()>d.  In these cases the
value of C<$@> is the compile error, or the argument to C<die> (which
will interpolate C<$!> and C<$?>).  (See also L<Fatal>, though.)
 
Under a few operating systems, C<$^E> may contain a more verbose error
indicator, such as in this case, "CDROM tray not closed."  Systems that
do not support extended error messages leave C<$^E> the same as C<$!>.
 
Finally, C<$?> may be set to a non-0 value if the external program
F</cdrom/install> fails.  The upper eight bits reflect specific error
conditions encountered by the program (the program's C<exit()> value).
The lower eight bits reflect mode of failure, like signal death and
core dump information.  See L<wait(2)> for details.  In contrast to
C<$!> and C<$^E>, which are set only if an error condition is detected,
the variable C<$?> is set on each C<wait> or pipe C<close>,
overwriting the old value.  This is more like C<$@>, which on every
C<eval()> is always set on failure and cleared on success.
 
For more details, see the individual descriptions at C<$@>, C<$!>,
C<$^E>, and C<$?>.
 
=over 8
 
=item ${^CHILD_ERROR_NATIVE}
X<$^CHILD_ERROR_NATIVE>
 
The native status returned by the last pipe close, backtick (C<``>)
command, successful call to C<wait()> or C<waitpid()>, or from the
C<system()> operator.  On POSIX-like systems this value can be decoded
with the WIFEXITED, WEXITSTATUS, WIFSIGNALED, WTERMSIG, WIFSTOPPED, and
WSTOPSIG functions provided by the L<POSIX> module.
 
Under VMS this reflects the actual VMS exit status; i.e. it is the
same as C<$?> when the pragma C<use vmsish 'status'> is in effect.
 
This variable was added in Perl v5.10.0.
 
=item $EXTENDED_OS_ERROR
 
=item $^E
X<$^E> X<$EXTENDED_OS_ERROR>
 
Error information specific to the current operating system.  At the
moment, this differs from C<L</$!>> under only VMS, OS/2, and Win32 (and
for MacPerl).  On all other platforms, C<$^E> is always just the same
as C<$!>.
 
Under VMS, C<$^E> provides the VMS status value from the last system
error.  This is more specific information about the last system error
than that provided by C<$!>.  This is particularly important when C<$!>
is set to B<EVMSERR>.
 
Under OS/2, C<$^E> is set to the error code of the last call to OS/2
API either via CRT, or directly from perl.
 
Under Win32, C<$^E> always returns the last error information reported
by the Win32 call C<GetLastError()> which describes the last error
from within the Win32 API.  Most Win32-specific code will report errors
via C<$^E>.  ANSI C and Unix-like calls set C<errno> and so most
portable Perl code will report errors via C<$!>.
 
Caveats mentioned in the description of C<L</$!>> generally apply to
C<$^E>, also.
 
This variable was added in Perl 5.003.
 
Mnemonic: Extra error explanation.
 
=item $EXCEPTIONS_BEING_CAUGHT
 
=item $^S
X<$^S> X<$EXCEPTIONS_BEING_CAUGHT>
 
Current state of the interpreter.
 
    $^S         State
    ---------   -------------------------------------
    undef       Parsing module, eval, or main program
    true (1)    Executing an eval or try block
    false (0)   Otherwise
 
The first state may happen in C<$SIG{__DIE__}> and C<$SIG{__WARN__}>
handlers.
 
The English name $EXCEPTIONS_BEING_CAUGHT is slightly misleading, because
the C<undef> value does not indicate whether exceptions are being caught,
since compilation of the main program does not catch exceptions.
 
This variable was added in Perl 5.004.
 
=item $WARNING
 
=item $^W
X<$^W> X<$WARNING>
 
The current value of the warning switch, initially true if B<-w> was
used, false otherwise, but directly modifiable.
 
See also L<warnings>.
 
Mnemonic: related to the B<-w> switch.
 
=item ${^WARNING_BITS}
X<${^WARNING_BITS}>
 
The current set of warning checks enabled by the C<use warnings> pragma.
It has the same scoping as the C<$^H> and C<%^H> variables.  The exact
values are considered internal to the L<warnings> pragma and may change
between versions of Perl.
 
Each time a statement completes being compiled, the current value of
C<${^WARNING_BITS}> is stored with that statement, and can later be
retrieved via C<(caller($level))[9]>.
 
This variable was added in Perl v5.6.0.
 
=item $OS_ERROR
 
=item $ERRNO
 
=item $!
X<$!> X<$ERRNO> X<$OS_ERROR>
 
When referenced, C<$!> retrieves the current value
of the C C<errno> integer variable.
If C<$!> is assigned a numerical value, that value is stored in C<errno>.
When referenced as a string, C<$!> yields the system error string
corresponding to C<errno>.
 
Many system or library calls set C<errno> if they fail,
to indicate the cause of failure.  They usually do B<not>
set C<errno> to zero if they succeed and may set C<errno> to a
non-zero value on success.  This means C<errno>, hence C<$!>, is
meaningful only I<immediately> after a B<failure>:
 
    if (open my $fh, "<", $filename) {
        # Here $! is meaningless.
        ...
    }
    else {
        # ONLY here is $! meaningful.
        ...
        # Already here $! might be meaningless.
    }
    # Since here we might have either success or failure,
    # $! is meaningless.
 
Here, I<meaningless> means that C<$!> may be unrelated to the outcome
of the C<open()> operator.  Assignment to C<$!> is similarly ephemeral.
It can be used immediately before invoking the C<die()> operator,
to set the exit value, or to inspect the system error string
corresponding to error I<n>, or to restore C<$!> to a meaningful state.
 
Perl itself may set C<errno> to a non-zero on failure even if no
system call is performed.
 
Mnemonic: What just went bang?
 
=item %OS_ERROR
 
=item %ERRNO
 
=item %!
X<%!> X<%OS_ERROR> X<%ERRNO>
 
Each element of C<%!> has a true value only if C<$!> is set to that
value.  For example, C<$!{ENOENT}> is true if and only if the current
value of C<$!> is C<ENOENT>; that is, if the most recent error was "No
such file or directory" (or its moral equivalent: not all operating
systems give that exact error, and certainly not all languages).  The
specific true value is not guaranteed, but in the past has generally
been the numeric value of C<$!>.  To check if a particular key is
meaningful on your system, use C<exists $!{the_key}>; for a list of legal
keys, use C<keys %!>.  See L<Errno> for more information, and also see
L</$!>.
 
This variable was added in Perl 5.005.
 
=item $CHILD_ERROR
 
=item $?
X<$?> X<$CHILD_ERROR>
 
The status returned by the last pipe close, backtick (C<``>) command,
successful call to C<wait()> or C<waitpid()>, or from the C<system()>
operator.  This is just the 16-bit status word returned by the
traditional Unix C<wait()> system call (or else is made up to look
like it).  Thus, the exit value of the subprocess is really (C<<< $? >>
8 >>>), and C<$? & 127> gives which signal, if any, the process died
from, and C<$? & 128> reports whether there was a core dump.
 
Additionally, if the C<h_errno> variable is supported in C, its value
is returned via C<$?> if any C<gethost*()> function fails.
 
If you have installed a signal handler for C<SIGCHLD>, the
value of C<$?> will usually be wrong outside that handler.
 
Inside an C<END> subroutine C<$?> contains the value that is going to be
given to C<exit()>.  You can modify C<$?> in an C<END> subroutine to
change the exit status of your program.  For example:
 
    END {
        $? = 1 if $? == 255;  # die would make it 255
    }
 
Under VMS, the pragma C<use vmsish 'status'> makes C<$?> reflect the
actual VMS exit status, instead of the default emulation of POSIX
status; see L<perlvms/$?> for details.
 
Mnemonic: similar to B<sh> and B<ksh>.
 
=item $EVAL_ERROR
 
=item $@
X<$@> X<$EVAL_ERROR>
 
The Perl error from the last C<eval> operator, i.e. the last exception that
was caught.  For C<eval BLOCK>, this is either a runtime error message or the
string or reference C<die> was called with.  The C<eval STRING> form also
catches syntax errors and other compile time exceptions.
 
If no error occurs, C<eval> sets C<$@> to the empty string.
 
Warning messages are not collected in this variable.  You can, however,
set up a routine to process warnings by setting C<$SIG{__WARN__}> as
described in L</%SIG>.
 
Mnemonic: Where was the error "at"?
 
=back
 
=head2 Variables related to the interpreter state
 
These variables provide information about the current interpreter state.
 
=over 8
 
=item $COMPILING
 
=item $^C
X<$^C> X<$COMPILING>
 
The current value of the flag associated with the B<-c> switch.
Mainly of use with B<-MO=...> to allow code to alter its behavior
when being compiled, such as for example to C<AUTOLOAD> at compile
time rather than normal, deferred loading.  Setting
C<$^C = 1> is similar to calling C<B::minus_c>.
 
This variable was added in Perl v5.6.0.
 
=item $DEBUGGING
 
=item $^D
X<$^D> X<$DEBUGGING>
 
The current value of the debugging flags.  May be read or set.  Like its
L<command-line equivalent|perlrun/B<-D>I<letters>>, you can use numeric
or symbolic values, e.g. C<$^D = 10> or C<$^D = "st">.  See
L<perlrun/B<-D>I<number>>.  The contents of this variable also affects the
debugger operation.  See L<perldebguts/Debugger Internals>.
 
Mnemonic: value of B<-D> switch.
 
=item ${^GLOBAL_PHASE}
X<${^GLOBAL_PHASE}>
 
The current phase of the perl interpreter.
 
Possible values are:
 
=over 8
 
=item CONSTRUCT
 
The C<PerlInterpreter*> is being constructed via C<perl_construct>.  This
value is mostly there for completeness and for use via the
underlying C variable C<PL_phase>.  It's not really possible for Perl
code to be executed unless construction of the interpreter is
finished.
 
=item START
 
This is the global compile-time.  That includes, basically, every
C<BEGIN> block executed directly or indirectly from during the
compile-time of the top-level program.
 
This phase is not called "BEGIN" to avoid confusion with
C<BEGIN>-blocks, as those are executed during compile-time of any
compilation unit, not just the top-level program.  A new, localised
compile-time entered at run-time, for example by constructs as
C<eval "use SomeModule"> are not global interpreter phases, and
therefore aren't reflected by C<${^GLOBAL_PHASE}>.
 
=item CHECK
 
Execution of any C<CHECK> blocks.
 
=item INIT
 
Similar to "CHECK", but for C<INIT>-blocks, not C<CHECK> blocks.
 
=item RUN
 
The main run-time, i.e. the execution of C<PL_main_root>.
 
=item END
 
Execution of any C<END> blocks.
 
=item DESTRUCT
 
Global destruction.
 
=back
 
Also note that there's no value for UNITCHECK-blocks.  That's because
those are run for each compilation unit individually, and therefore is
not a global interpreter phase.
 
Not every program has to go through each of the possible phases, but
transition from one phase to another can only happen in the order
described in the above list.
 
An example of all of the phases Perl code can see:
 
    BEGIN { print "compile-time: ${^GLOBAL_PHASE}\n" }
 
    INIT  { print "init-time: ${^GLOBAL_PHASE}\n" }
 
    CHECK { print "check-time: ${^GLOBAL_PHASE}\n" }
 
    {
        package Print::Phase;
 
        sub new {
            my ($class, $time) = @_;
            return bless \$time, $class;
        }
 
        sub DESTROY {
            my $self = shift;
            print "$$self: ${^GLOBAL_PHASE}\n";
        }
    }
 
    print "run-time: ${^GLOBAL_PHASE}\n";
 
    my $runtime = Print::Phase->new(
        "lexical variables are garbage collected before END"
    );
 
    END   { print "end-time: ${^GLOBAL_PHASE}\n" }
 
    our $destruct = Print::Phase->new(
        "package variables are garbage collected after END"
    );
 
This will print out
 
    compile-time: START
    check-time: CHECK
    init-time: INIT
    run-time: RUN
    lexical variables are garbage collected before END: RUN
    end-time: END
    package variables are garbage collected after END: DESTRUCT
 
This variable was added in Perl 5.14.0.
 
=item $^H
X<$^H>
 
WARNING: This variable is strictly for
internal use only.  Its availability,
behavior, and contents are subject to change without notice.
 
This variable contains compile-time hints for the Perl interpreter.  At the
end of compilation of a BLOCK the value of this variable is restored to the
value when the interpreter started to compile the BLOCK.
 
Each time a statement completes being compiled, the current value of
C<$^H> is stored with that statement, and can later be retrieved via
C<(caller($level))[8]>.  See L<perlfunc/caller EXPR>.
 
When perl begins to parse any block construct that provides a lexical scope
(e.g., eval body, required file, subroutine body, loop body, or conditional
block), the existing value of C<$^H> is saved, but its value is left unchanged.
When the compilation of the block is completed, it regains the saved value.
Between the points where its value is saved and restored, code that
executes within BEGIN blocks is free to change the value of C<$^H>.
 
This behavior provides the semantic of lexical scoping, and is used in,
for instance, the C<use strict> pragma.
 
The contents should be an integer; different bits of it are used for
different pragmatic flags.  Here's an example:
 
    sub add_100 { $^H |= 0x100 }
 
    sub foo {
        BEGIN { add_100() }
        bar->baz($boon);
    }
 
Consider what happens during execution of the BEGIN block.  At this point
the BEGIN block has already been compiled, but the body of C<foo()> is still
being compiled.  The new value of C<$^H>
will therefore be visible only while
the body of C<foo()> is being compiled.
 
Substitution of C<BEGIN { add_100() }> block with:
 
    BEGIN { require strict; strict->import('vars') }
 
demonstrates how C<use strict 'vars'> is implemented.  Here's a conditional
version of the same lexical pragma:
 
    BEGIN {
        require strict; strict->import('vars') if $condition
    }
 
This variable was added in Perl 5.003.
 
=item %^H
X<%^H>
 
The C<%^H> hash provides the same scoping semantics as L<C<$^H>|/$^H>.  This
makes it useful for implementing lexically scoped pragmas.  See L<perlpragma>.
All the entries are stringified when accessed at runtime, so only simple values
can be accommodated.  This means no references to objects, for example.
 
Each time a statement completes being compiled, the current value of
C<%^H> is stored with that statement, and can later be retrieved via
C<(caller($level))[10]>.  See L<perlfunc/caller EXPR>.
 
When putting items into C<%^H>, in order to avoid conflicting with other
users of the hash there is a convention regarding which keys to use.
A module should use only keys that begin with the module's name (the
name of its main package) and a "/" character.  For example, a module
C<Foo::Bar> should use keys such as C<Foo::Bar/baz>.
 
This variable was added in Perl v5.6.0.
 
=item ${^OPEN}
X<${^OPEN}>
 
An internal variable used by L<PerlIO>.  A string in two parts, separated
by a C<\0> byte, the first part describes the input layers, the second
part describes the output layers.
 
This is the mechanism that applies the lexical effects of the L<open>
pragma, and the main program scope effects of the C<io> or C<D> options
for the L<-C command-line switch|perlrun/-C [I<numberE<sol>list>]> and
L<PERL_UNICODE environment variable|perlrun/PERL_UNICODE>.
 
The functions C<accept()>, C<open()>, C<pipe()>, C<readpipe()> (as well
as the related C<qx> and C<`STRING`> operators), C<socket()>,
C<socketpair()>, and C<sysopen()> are affected by the lexical value of
this variable.  The implicit L</ARGV> handle opened by C<readline()> (or
the related C<< <> >> and C<<< <<>> >>> operators) on passed filenames is
also affected (but not if it opens C<STDIN>).  If this variable is not
set, these functions will set the default layers as described in
L<PerlIO/Defaults and how to override them>.
 
C<open()> ignores this variable (and the default layers) when called with
3 arguments and explicit layers are specified.  Indirect calls to these
functions via modules like L<IO::Handle> are not affected as they occur
in a different lexical scope.  Directory handles such as opened by
C<opendir()> are not currently affected.
 
This variable was added in Perl v5.8.0.
 
=item $PERLDB
 
=item $^P
X<$^P> X<$PERLDB>
 
The internal variable for debugging support.  The meanings of the
various bits are subject to change, but currently indicate:
 
=over 6
 
=item 0x01
 
Debug subroutine enter/exit.
 
=item 0x02
 
Line-by-line debugging.  Causes C<DB::DB()> subroutine to be called for
each statement executed.  Also causes saving source code lines (like
0x400).
 
=item 0x04
 
Switch off optimizations.
 
=item 0x08
 
Preserve more data for future interactive inspections.
 
=item 0x10
 
Keep info about source lines on which a subroutine is defined.
 
=item 0x20
 
Start with single-step on.
 
=item 0x40
 
Use subroutine address instead of name when reporting.
 
=item 0x80
 
Report C<goto &subroutine> as well.
 
=item 0x100
 
Provide informative "file" names for evals based on the place they were compiled.
 
=item 0x200
 
Provide informative names to anonymous subroutines based on the place they
were compiled.
 
=item 0x400
 
Save source code lines into C<@{"_<$filename"}>.
 
=item 0x800
 
When saving source, include evals that generate no subroutines.
 
=item 0x1000
 
When saving source, include source that did not compile.
 
=back
 
Some bits may be relevant at compile-time only, some at
run-time only.  This is a new mechanism and the details may change.
See also L<perldebguts>.
 
=item ${^TAINT}
X<${^TAINT}>
 
Reflects if taint mode is on or off.  1 for on (the program was run with
B<-T>), 0 for off, -1 when only taint warnings are enabled (i.e. with
B<-t> or B<-TU>).
 
Note: if your perl was built without taint support (see L<perlsec>),
then C<${^TAINT}> will always be 0, even if the program was run with B<-T>).
 
This variable is read-only.
 
This variable was added in Perl v5.8.0.
 
=item ${^SAFE_LOCALES}
X<${^SAFE_LOCALES}>
 
Reflects if safe locale operations are available to this perl (when the
value is 1) or not (the value is 0).  This variable is always 1 if the
perl has been compiled without threads.  It is also 1 if this perl is
using thread-safe locale operations.  Note that an individual thread may
choose to use the global locale (generally unsafe) by calling
L<perlapi/switch_to_global_locale>.  This variable currently is still
set to 1 in such threads.
 
This variable is read-only.
 
This variable was added in Perl v5.28.0.
 
=item ${^UNICODE}
X<${^UNICODE}>
 
Reflects certain Unicode settings of Perl.  See
L<perlrun|perlrun/-C [numberE<sol>list]> documentation for the C<-C>
switch for more information about the possible values.
 
This variable is set during Perl startup and is thereafter read-only.
 
This variable was added in Perl v5.8.2.
 
=item ${^UTF8CACHE}
X<${^UTF8CACHE}>
 
This variable controls the state of the internal UTF-8 offset caching code.
1 for on (the default), 0 for off, -1 to debug the caching code by checking
all its results against linear scans, and panicking on any discrepancy.
 
This variable was added in Perl v5.8.9.  It is subject to change or
removal without notice, but is currently used to avoid recalculating the
boundaries of multi-byte UTF-8-encoded characters.
 
=item ${^UTF8LOCALE}
X<${^UTF8LOCALE}>
 
This variable indicates whether a UTF-8 locale was detected by perl at
startup.  This information is used by perl when it's in
adjust-utf8ness-to-locale mode (as when run with the C<-CL> command-line
switch); see L<perlrun|perlrun/-C [numberE<sol>list]> for more info on
this.
 
This variable was added in Perl v5.8.8.
 
=back
 
=head2 Deprecated and removed variables
 
Deprecating a variable announces the intent of the perl maintainers to
eventually remove the variable from the language.  It may still be
available despite its status.  Using a deprecated variable triggers
a warning.
 
Once a variable is removed, its use triggers an error telling you
the variable is unsupported.
 
See L<perldiag> for details about error messages.
 
=over 8
 
=item $#
X<$#>
 
C<$#> was a variable that could be used to format printed numbers.
After a deprecation cycle, its magic was removed in Perl v5.10.0 and
using it now triggers a warning: C<$# is no longer supported>.
 
This is not the sigil you use in front of an array name to get the
last index, like C<$#array>.  That's still how you get the last index
of an array in Perl.  The two have nothing to do with each other.
 
Deprecated in Perl 5.
 
Removed in Perl v5.10.0.
 
=item $*
X<$*>
 
C<$*> was a variable that you could use to enable multiline matching.
After a deprecation cycle, its magic was removed in Perl v5.10.0.
Using it now triggers a warning: C<$* is no longer supported>.
You should use the C</s> and C</m> regexp modifiers instead.
 
Deprecated in Perl 5.
 
Removed in Perl v5.10.0.
 
=item $[
X<$[>
 
This variable stores the index of the first element in an array, and
of the first character in a substring.  The default is 0, but you could
theoretically set it to 1 to make Perl behave more like B<awk> (or Fortran)
when subscripting and when evaluating the index() and substr() functions.
 
As of release 5 of Perl, assignment to C<$[> is treated as a compiler
directive, and cannot influence the behavior of any other file.
(That's why you can only assign compile-time constants to it.)
Its use is highly discouraged.
 
Prior to Perl v5.10.0, assignment to C<$[> could be seen from outer lexical
scopes in the same file, unlike other compile-time directives (such as
L<strict>).  Using local() on it would bind its value strictly to a lexical
block.  Now it is always lexically scoped.
 
As of Perl v5.16.0, it is implemented by the L<arybase> module.
 
As of Perl v5.30.0, or under C<use v5.16>, or C<no feature "array_base">,
C<$[> no longer has any effect, and always contains 0.
Assigning 0 to it is permitted, but any other value will produce an error.
 
Mnemonic: [ begins subscripts.
 
Deprecated in Perl v5.12.0.
 
=item ${^ENCODING}
X<${^ENCODING}>
 
This variable is no longer supported.
 
It used to hold the I<object reference> to the C<Encode> object that was
used to convert the source code to Unicode.
 
Its purpose was to allow your non-ASCII Perl
scripts not to have to be written in UTF-8; this was
useful before editors that worked on UTF-8 encoded text were common, but
that was long ago.  It caused problems, such as affecting the operation
of other modules that weren't expecting it, causing general mayhem.
 
If you need something like this functionality, it is recommended that use
you a simple source filter, such as L<Filter::Encoding>.
 
If you are coming here because code of yours is being adversely affected
by someone's use of this variable, you can usually work around it by
doing this:
 
 local ${^ENCODING};
 
near the beginning of the functions that are getting broken.  This
undefines the variable during the scope of execution of the including
function.
 
This variable was added in Perl 5.8.2 and removed in 5.26.0.
Setting it to anything other than C<undef> was made fatal in Perl 5.28.0.
 
=item ${^WIN32_SLOPPY_STAT}
X<${^WIN32_SLOPPY_STAT}> X<sitecustomize> X<sitecustomize.pl>
 
This variable no longer has any function.
 
This variable was added in Perl v5.10.0 and removed in Perl v5.34.0.
 
=back
 
=cut
