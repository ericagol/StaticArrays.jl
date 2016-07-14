@testset "MMatrix" begin
    @testset "Inner Constructors" begin
        @test MMatrix{1,1,Int,1}((1,)).data === (1,)
        @test MMatrix{1,1,Float64,1}((1,)).data === (1.0,)
        @test MMatrix{2,2,Float64,4}((1, 1.0, 1, 1)).data === (1.0, 1.0, 1.0, 1.0)
        @test isa(MMatrix{1,1,Int,1}(), MMatrix{1,1,Int,1})
        @test isa(MMatrix{1,1,Int}(), MMatrix{1,1,Int,1})

        # Bad input
        @test_throws Exception MMatrix{2,1,Int,2}((1,))
        @test_throws Exception MMatrix{1,1,Int,1}(())

        # Bad parameters
        @test_throws Exception MMatrix{1,1,Int,2}((1,))
        @test_throws Exception MMatrix{1,1,1,1}((1,))
        @test_throws Exception MMatrix{1,2,Int,1}((1,))
        @test_throws Exception MMatrix{2,1,Int,1}((1,))
    end

    @testset "Outer constructors and macro" begin
        @test MMatrix{1,1,Int}((1,)).data === (1,)
        @test MMatrix{1,1}((1,)).data === (1,)
        @test MMatrix{1}((1,)).data === (1,)

        @test MMatrix{2,2,Int}((1,2,3,4)).data === (1,2,3,4)
        @test MMatrix{2,2}((1,2,3,4)).data === (1,2,3,4)
        @test MMatrix{2}((1,2,3,4)).data === (1,2,3,4)

        @test ((@MMatrix [1.0])::MMatrix{1,1}).data === (1.0,)
        @test ((@MMatrix [1 2])::MMatrix{1,2}).data === (1, 2)
        @test ((@MMatrix [1 ; 2])::MMatrix{2,1}).data === (1, 2)
        @test ((@MMatrix [1 2 ; 3 4])::MMatrix{2,2}).data === (1, 3, 2, 4)

        @test (ex = macroexpand(:(@MMatrix [1 2; 3])); isa(ex, Expr) && ex.head == :error)
    end

    @testset "Methods" begin
        m = @MMatrix [11 13; 12 14]

        @test isimmutable(m) == false

        @test m[1] === 11
        @test m[2] === 12
        @test m[3] === 13
        @test m[4] === 14

        @test Tuple(m) === (11, 12, 13, 14)

        @test size(m) === (2, 2)
        @test size(typeof(m)) === (2, 2)
        @test size(MMatrix{2,2}) === (2, 2)

        @test size(m, 1) === 2
        @test size(m, 2) === 2
        @test size(typeof(m), 1) === 2
        @test size(typeof(m), 2) === 2

        @test length(m) === 4
    end

    @testset "setindex!" begin
        m = @MMatrix [0 0; 0 0]
        m[1] = 11
        m[2] = 12
        m[3] = 13
        m[4] = 14
        @test m.data === (11, 12, 13, 14)
    end
end
