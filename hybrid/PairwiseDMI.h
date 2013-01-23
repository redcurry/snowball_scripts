#include <string>
using namespace std;

enum DMIType
{
  DA,  // Pos_1: derived parental 1,   Pos_2: ancestral parental 2
  AD,  // Pos_1: ancestral parental 1, Pos_2: derived parental 2
  DD   // Pos_1: derived parental 1,   Pos_2: derived parental 2
};

class PairwiseDMI
{
  public:

    PairwiseDMI(DMIType type, int pos_1, int pos_2) :
      m_Type(type), m_Pos_1(pos_1), m_Pos_2(pos_2) {}

    PairwiseDMI(string type, int pos_1, int pos_2)
    {
      // Format 1
      if(type == "A1")
      {
        m_Type = DA;
        m_Pos_1 = pos_1;
        m_Pos_2 = pos_2;
      }
      else if(type == "A2")
      {
        m_Type = AD;
        m_Pos_1 = pos_2;
        m_Pos_2 = pos_1;
      }
      else if(type == "P")
      {
        m_Type = DD;
        m_Pos_1 = pos_1;
        m_Pos_2 = pos_2;
      }

      // Format 2
      if(type == "DA")
      {
        m_Type = DA;
        m_Pos_1 = pos_1;
        m_Pos_2 = pos_2;
      }
      else if(type == "AD")
      {
        m_Type = AD;
        m_Pos_1 = pos_1;
        m_Pos_2 = pos_2;
      }
      else if(type == "DD")
      {
        m_Type = DD;
        m_Pos_1 = pos_1;
        m_Pos_2 = pos_2;
      }
    }

    inline DMIType getType() const
      { return m_Type; }
    inline int getPosition1() const
      { return m_Pos_1; }
    inline int getPosition2() const
      { return m_Pos_2; }

  private:

    DMIType m_Type;
    int m_Pos_1;
    int m_Pos_2;
};
