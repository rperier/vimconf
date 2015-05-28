#include <cstdio>
#include "clang/Lex/PPCallbacks.h"
#include "clang/Lex/Preprocessor.h"
#include "clang/Frontend/FrontendActions.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"
#include "clang/Rewrite/Core/Rewriter.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/FrontendPluginRegistry.h"
#include "clang/Frontend/TextDiagnosticPrinter.h"
#include "clang/ASTMatchers/ASTMatchers.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"
#include "clang/Driver/Options.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Signals.h"
#include "llvm/Option/OptTable.h"

using namespace clang::ast_matchers;
using namespace llvm;

static const char* FunctionID = "function-id";

static cl::OptionCategory ClangTypeInfoCategory("clang-showme options");
static cl::opt<bool> Debug("debug",
    cl::desc("enable debugging mode"),
    cl::cat(ClangTypeInfoCategory)
);

static void debug(const char *format, ...)
{
    va_list ap;

    if (!Debug)
        return;
    va_start(ap, format);
    vfprintf(stderr, format, ap);
    va_end(ap);
}

class FunctionCallback : public clang::ast_matchers::MatchFinder::MatchCallback
{

public:

    FunctionCallback():
        m_beginLine(0),
        m_endLine(0)
    {
    }

    virtual void run(const clang::ast_matchers::MatchFinder::MatchResult &Result) final
    {
        if (const clang::FunctionDecl *f = Result.Nodes.getDeclAs<clang::FunctionDecl>(FunctionID))
        {
            const clang::SourceManager *sourceManager = Result.SourceManager;
            m_fileName = sourceManager->getFilename(f->getLocation());

            debug("FunctionDecl found\n");
            if (Debug) {
                debug("LocStart: spellingLine = %u, expansionLine = %u, presumedLine = %u\n", sourceManager->getSpellingLineNumber(f->getLocStart()),
                    sourceManager->getExpansionLineNumber(f->getLocStart()), sourceManager->getPresumedLineNumber(f->getLocStart()));
                debug("LocEnd: spellingLine = %u, expansionLine = %u, presumedLine = %u\n", sourceManager->getSpellingLineNumber(f->getLocEnd()),
                    sourceManager->getExpansionLineNumber(f->getLocEnd()), sourceManager->getPresumedLineNumber(f->getLocEnd()));
            }
            if (f->isThisDeclarationADefinition()) {
                m_beginLine = sourceManager->getSpellingLineNumber(f->getLocStart());
                m_endLine = sourceManager->getSpellingLineNumber(f->getBody()->getLocStart()) - 1;
                debug("this is a definition, beginLine = %u, endLine = %u\n", m_beginLine, m_endLine);
            } else {
                if (!f->getPreviousDecl()) {
                    debug("NoPreviousDecl\n");
                    m_beginLine = sourceManager->getExpansionLineNumber(f->getLocStart());
                    m_endLine = sourceManager->getExpansionLineNumber(f->getLocEnd());

                   debug("beginLine = %u, endLine = %u\n", m_beginLine, m_endLine);
                }
                else {
                    m_endLine = sourceManager->getExpansionLineNumber(f->getLocEnd());
                    debug("PreviousDecl = %p, endLine = %u\n", m_endLine);
                }
            }
        }
    }

    const StringRef &fileName() const
    {
        return m_fileName;
    }

    unsigned beginLine() const
    {
        return m_beginLine;
    }

    unsigned endLine() const
    {
        return m_endLine;
    }

    bool hasValidMatch() const
    {
        return !m_fileName.empty() && (m_beginLine != 0) && (m_endLine != 0);
    }

private:
    StringRef m_fileName;
    unsigned m_beginLine;
    unsigned m_endLine;
};

static std::unique_ptr<opt::OptTable> Options(clang::driver::createDriverOptTable());
static cl::extrahelp CommonHelp(clang::tooling::CommonOptionsParser::HelpMessage);
static cl::extrahelp MoreHelp(
    "\nclang-showme will find declarations of functions or variables"
    "\nspecified on the command line, and display their locations to the standard output.\n");
static cl::opt<std::string> Function("function",
    cl::desc("function name to find"),
    cl::cat(ClangTypeInfoCategory)
);
static cl::opt<std::string> Macro("macro",
    cl::desc("macro name to find"),
    cl::cat(ClangTypeInfoCategory)
);

class MacroMatcher: public clang::PPCallbacks
{
public:

    MacroMatcher(const clang::CompilerInstance &compilerInstance):
         m_compilerInstance(compilerInstance)
    {
    }

    virtual void FileChanged(clang::SourceLocation Loc, FileChangeReason Reason, clang::SrcMgr::CharacteristicKind FileType, clang::FileID PrevFID)
    {
        StringRef file = m_compilerInstance.getSourceManager().getFilename(Loc);
        if (!file.empty()) {
            debug("%s: %s\n", __func__, file.str().c_str());
            m_currentFile = file;
        }
    }

    virtual void MacroDefined(const clang::Token &MacroNameTok, const clang::MacroDirective *MD)
    {
        if (Macro == MacroNameTok.getIdentifierInfo()->getName()) {
            const clang::SourceManager &sourceManager = m_compilerInstance.getSourceManager();
            unsigned line = sourceManager.getSpellingLineNumber(MD->getLocation());

            debug("getLocation: spellingLine = %u, expansionLine = %u, presumedLine = %u\n", sourceManager.getSpellingLineNumber(MD->getLocation()),
                sourceManager.getExpansionLineNumber(MD->getLocation()), sourceManager.getPresumedLineNumber(MD->getLocation()));

            printf("%s:%u:%u\n", m_currentFile.str().c_str(), line, line);
            exit(0);
        }
    }
private:
     const clang::CompilerInstance &m_compilerInstance;
     StringRef m_currentFile;
};

class MacroMatcherAction: public clang::PreprocessOnlyAction
{
public:

    virtual void ExecuteAction()
    {
        getCompilerInstance().getPreprocessor().
            addPPCallbacks(std::unique_ptr<MacroMatcher>(new MacroMatcher(getCompilerInstance())));
        clang::PreprocessOnlyAction::ExecuteAction();
    }
};

int main(int argc, const char *argv[])
{
    sys::PrintStackTraceOnErrorSignal();
    clang::tooling::CommonOptionsParser Options(argc, argv, ClangTypeInfoCategory);
    clang::tooling::ClangTool Tool(Options.getCompilations(),
        Options.getSourcePathList());
    if (!Function.empty()) {
        clang::ast_matchers::DeclarationMatcher M = functionDecl(decl().bind(FunctionID), hasName(Function));
        FunctionCallback functionCallback;
        clang::ast_matchers::MatchFinder finder;
        finder.addMatcher(M, &functionCallback);

        Tool.run(clang::tooling::newFrontendActionFactory(&finder).get());
        if (functionCallback.hasValidMatch())
            printf("%s:%u:%u\n", functionCallback.fileName().str().c_str(), functionCallback.beginLine(), functionCallback.endLine());
    } else if (!Macro.empty()) {
        Tool.run(clang::tooling::newFrontendActionFactory<MacroMatcherAction>().get());
    }
    return 0;
}

