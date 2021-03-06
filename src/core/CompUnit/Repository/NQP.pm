class CompUnit::Repository::NQP does CompUnit::Repository {
    method need(
        CompUnit::DependencySpecification $spec,
        CompUnit::PrecompilationRepository $precomp = self.precomp-repository(),
    )
        returns CompUnit:D
    {
        if $spec.from eq 'NQP' {
            my $nqp := nqp::gethllsym('perl6', 'ModuleLoader');

            return CompUnit.new(
                :short-name($spec.short-name),
                :handle(CompUnit::Handle.new($nqp.load_module($spec.short-name, {:from<NQP>}))),
                :repo(self),
                :repo-id($spec.short-name),
                :from($spec.from),
            );
        }

        return self.next-repo.need($spec, $precomp) if self.next-repo;
        X::CompUnit::UnsatisfiedDependency.new(:specification($spec)).throw;
    }

    method loaded() {
        []
    }

    method id() {
        'NQP'
    }

    method path-spec() {
        'nqp#'
    }
}

# vim: ft=perl6 expandtab sw=4
