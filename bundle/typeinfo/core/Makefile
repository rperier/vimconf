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
    -lclangBasic -lLLVMSupport

CXXFLAGS += -Wall -Wextra -O3

all: clang-typeinfo

clang-typeinfo: clang-typeinfo.cpp
	$(CXX) $< -o $@ $(CXXFLAGS) $(LIB) `llvm-config --cxxflags --ldflags --libs all --system-libs`

clean:
	$(RM) clang-typeinfo

