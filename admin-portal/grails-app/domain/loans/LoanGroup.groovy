package loans

class LoanGroup {
    int id,version
    String code
    Integer start_range,end_range,instruments
    Float interest
    static constraints = {
        code nullable: true
        start_range nullable: true
        end_range nullable: true
        instruments nullable: true
        interest nullable: true
    }

    static mapping = {
        table name: 'gen_loan_group'
    }
}
