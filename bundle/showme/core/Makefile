LIB = -fno-rtti \
    -lclangFrontend -lclangDriver -lclangTooling \
    -lclangDriver -lclangTooling -lclangFrontendTool \
    -lclangFrontend -lclangDriver -lclangSerialization \
    -lclangCodeGen -lclangParse -lclangSema \
    -lclangStaticAnalyzerFrontend -lclangStaticAnalyzerCheckers \
    -lclangStaticAnalyzerCore -lclangAnalysis \
    -lclangARCMigrate -lclangRewriteFrontend \
    -lclangEdit  -lclangAST \
    -lclangLex -lclangBasic  -lclangCodeGen -lclangSema \
    -lclangAnalysis  -lclangAST -lclangParse -lclangLex \
    -lclangASTMatchers \
    -lclangBasic -lLLVMSupport -lpthread -ldl -lncurses -lz

CXXFLAGS += -Wall -Wextra -O3

all: clang-showme

clang-showme: clang-showme.cpp
	$(CXX) $< -o $@ $(CXXFLAGS) $(LIB) `llvm-config --cxxflags --ldflags --libs all`

clean:
	$(RM) clang-showme

