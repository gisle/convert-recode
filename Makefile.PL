use ExtUtils::MakeMaker;

$recode_version = `recode --version`;
warn "You need to have GNU recode installed before you can use Convert::Recode\n"
  unless $recode_version;

WriteMakefile(
    NAME	 => 'Convert::Recode',
    VERSION_FROM => 'Recode.pm',
    dist         => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
);
