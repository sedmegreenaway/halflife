# Makefile - mdlviewer.dsp

ifndef CFG
CFG=mdlviewer - Win32 Debug
endif
CC=gcc
CFLAGS=
CXX=g++
CXXFLAGS=$(CFLAGS)
RC=windres -O COFF
ifeq "$(CFG)"  "mdlviewer - Win32 Release"
CFLAGS+=-W -fexceptions -O2 -I../common -I../../common -DWIN32 -DNDEBUG -D_CONSOLE -D_MBCS
LD=$(CXX) $(CXXFLAGS)
LDFLAGS=
#LDFLAGS+=-Wl
#LIBS+=-lkernel32 -luser32 -lgdi32 -lwinspool -lcomdlg32 -ladvapi32 -lshell32 -lole32 -loleaut32 -luuid -lodbc32 -lodbccp32 -lopengl32 -lglu32 -lglut32
LIBS+=-lGL -lGLU -lglut
else
ifeq "$(CFG)"  "mdlviewer - Win32 Debug"
CFLAGS+=-W -fexceptions -g -O0 -I../common -I../../common -DWIN32 -D_DEBUG -D_CONSOLE -D_MBCS
LD=$(CXX) $(CXXFLAGS)
LDFLAGS=
#LDFLAGS+=-Wl
#LIBS+=-lglu32 -lkernel32 -luser32 -lgdi32 -lwinspool -lcomdlg32 -ladvapi32 -lshell32 -lole32 -loleaut32 -luuid -lodbc32 -lodbccp32 -lopengl32 -lglut32
LIBS+=-lGL -lGLU -lglut
endif
endif

ifndef TARGET
TARGET=mdlviewer
endif

.PHONY: all
all: $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -c $<

%.o: %.cc
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ -c $<

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ -c $<

%.o: %.cxx
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ -c $<

%.res: %.rc
	$(RC) $(CPPFLAGS) -o $@ -i $<

SOURCE_FILES= \
	../common/mathlib.c \
	mdlviewer.cpp \
	studio_render.cpp \
	studio_utils.cpp

HEADER_FILES= \
	../common/mathlib.h \
	mdlviewer.h

RESOURCE_FILES=

SRCS=$(SOURCE_FILES) $(HEADER_FILES) $(RESOURCE_FILES) 

OBJS=$(patsubst %.rc,%.res,$(patsubst %.cxx,%.o,$(patsubst %.cpp,%.o,$(patsubst %.cc,%.o,$(patsubst %.c,%.o,$(filter %.c %.cc %.cpp %.cxx %.rc,$(SRCS)))))))

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

.PHONY: clean
clean:
	-rm -f $(OBJS) $(TARGET) mdlviewer.dep

.PHONY: depends
depends:
	-$(CXX) $(CXXFLAGS) $(CPPFLAGS) -MM $(filter %.c %.cc %.cpp %.cxx,$(SRCS)) > mdlviewer.dep

-include mdlviewer.dep

